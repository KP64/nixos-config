{
  den.aspects.morgiana.nixos =
    { config, lib, ... }:
    let
      inherit (config.lib.securityHeader) mkCSP mkPP;
    in
    lib.mkMerge [
      (lib.mkIf config.services.searx.enable {
        sops.secrets.searxng = {
          owner = config.users.users.searx.name;
          restartUnits = [
            (
              if config.services.searx.configureUwsgi then
                config.systemd.services.uwsgi.name
              else
                config.systemd.services.searx.name
            )
          ];
        };

        services.caddy.virtualHosts.${config.services.searx.domain}.extraConfig = # caddy
          ''
            handle_path /static/* {
                root * ${config.services.searx.package}/share/static/
                file_server
            }
            reverse_proxy 127.0.0.1${config.services.searx.uwsgiConfig.http}

            header {
                Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
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
            }
          '';
      })
      {
        services.searx = {
          enable = true;
          domain = "searxng.${config.networking.domain}";
          redisCreateLocally = true; # Needed for Rate-Limit & bot protection
          configureUwsgi = true;
          uwsgiConfig.http = ":8888";

          limiterSettings.botdetection = {
            ipv4_prefix = 32;
            ipv6_prefix = 48;
            trusted_proxies = [
              "127.0.0.0/8"
              "::1"
            ];
            ip_limit = {
              filter_link_local = true;
              link_token = true;
            };
            ip_lists = {
              pass_searxng_org = true;
              pass_ip = [
                "192.168.2.0/24"
                "fe80::/10"
              ];
            };
          };

          settings = {
            # Just enable all formats because why not ;)
            search.formats = [
              "html"
              "csv"
              "rss"
              # NOTE: JSON is needed for Open-Webui
              "json"
            ];

            server = {
              base_url = "https://${config.services.searx.domain}";
              secret_key = config.sops.secrets.searxng.path;
              public_instance = true;
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
    ];
}
