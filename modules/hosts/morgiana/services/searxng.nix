toplevel@{ moduleWithSystem, ... }:
{
  den.aspects.morgiana.nixos = moduleWithSystem (
    { system, ... }:
    { config, lib, ... }:
    let
      inherit (config.lib.securityHeader) mkCSP mkPP;
    in
    lib.mkMerge [
      (lib.mkIf config.services.searx.enable {
        sops = {
          secrets.searxng = { };
          templates."searxng.env" = {
            restartUnits = [
              (
                if config.services.searx.configureUwsgi then
                  config.systemd.services.uwsgi.name
                else
                  config.systemd.services.searx.name
              )
            ];
            content = ''
              SEARX_SECRET_KEY=${config.sops.placeholder.searxng}
            '';
          };
        };

        systemd.services.caddy.serviceConfig.SupplementaryGroups = [ config.users.groups.searx.name ];
        services.caddy.virtualHosts.${config.services.searx.domain}.extraConfig = # caddy
          ''
            handle_path /static/* {
                root * ${config.services.searx.package}/share/static/
                file_server
            }
            reverse_proxy unix/${config.services.searx.uwsgiConfig.http-socket}

            header {
                Strict-Transport-Security "max-age=31536000; includeSubDomains"
                Content-Security-Policy "${
                  mkCSP {
                    default-src = "none";
                    script-src = "self";
                    style-src = [
                      "self"
                      "unsafe-inline"
                    ];
                    img-src = [
                      "self"
                      "data:"
                      "https:"
                    ];
                    font-src = "self";
                    connect-src = "self";
                    frame-ancestors = "none";
                    base-uri = "none";
                    form-action = "self";
                    frame-src = "https:";
                    media-src = "https:";
                  }
                }"
                X-Frame-Options SAMEORIGIN
                Permissions-Policy "${
                  mkPP {
                    camera = "()";
                    microphone = "()";
                    geolocation = "()";
                    usb = "()";
                    bluetooth = "()";
                    payment = "()";
                    accelerometer = "()";
                    gyroscope = "()";
                    magnetometer = "()";
                    midi = "()";
                    serial = "()";
                    hid = "()";
                  }
                }"
                Cross-Origin-Embedder-Policy credentialless
                Cross-Origin-Opener-Policy same-origin-allow-popups
                Cross-Origin-Resource-Policy same-site
            }
          '';
      })
      {
        services.searx = {
          enable = true;
          domain = "search.${config.networking.domain}";
          environmentFile = config.sops.templates."searxng.env".path;
          redisCreateLocally = true; # Needed for Rate-Limit & bot protection
          configureUwsgi = true;
          uwsgiConfig = {
            http-socket = "/run/searx/searx.sock";
            chmod-socket = "660";
          };

          limiterSettings.botdetection =
            let
              homeNet = toplevel.config.flake.topology.${system}.config.networks.home.cidrv6;
            in
            {
              ipv4_prefix = 32;
              ipv6_prefix = 48;
              trusted_proxies = [
                "127.0.0.0/8"
                "::1"
                homeNet
              ];
              ip_lists = {
                pass_searxng_org = true;
                pass_ip = [
                  homeNet
                  "fe80::/10"
                ];
              };
            };

          settings = {
            search.formats = [
              "html"
              # NOTE: JSON is needed for Open-Webui
              "json"
            ];

            server = {
              base_url = "https://${config.services.searx.domain}";
              secret_key = "$SEARX_SECRET_KEY";
              limiter = true;
              public_instance = true;
              http_protocol_version = "1.1"; # 1.0 is default for whatever reason
            };

            engines = lib.mapAttrsToList (name: value: { inherit name; } // value) {
              "fdroid".disabled = false;
              "geizhals".disabled = false;
              "gitlab".disabled = false;
              "codeberg".disabled = false;
              "gitea.com".disabled = false;
              "nixos wiki".disabled = false;
              "hackernews".disabled = false;
              "crates.io".disabled = false;
              "huggingface".disabled = false;
              "imdb".disabled = false;
              "imgur".disabled = false;
              "npm".disabled = false;
              "odysee".disabled = false;
              "ollama".disabled = false;
              "reddit".disabled = false;
              "rottentomatoes".disabled = false;
              "selfhst icons".disabled = false;
              "steam".disabled = false;
              "tmdb".disabled = false;
              "wallhaven".disabled = false;
              "lib.rs".disabled = false;
              "sourcehut".disabled = false;
              "minecraft wiki".disabled = false;
            };
          };
        };
      }
    ]
  );
}
