toplevel: {
  flake.modules.nixos.hosts-mahdi =
    { config, lib, ... }:
    let
      inherit (toplevel.config.flake.nixos) mkCSP mkPP;
    in
    {
      sops.secrets.searxng.owner = config.users.users.searx.name;

      services = {
        nginx.virtualHosts.${config.services.searx.domain} = {
          enableACME = true;
          acmeRoot = null;
          onlySSL = true;
          kTLS = true;
          extraConfig = # nginx
            ''
              add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
              add_header Content-Security-Policy "${
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
              }" always;
              add_header X-Frame-Options SAMEORIGIN always;
              add_header Permissions-Policy "${
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
              }" always;
            '';
        };

        searx = {
          enable = true;
          domain = "searxng.${config.networking.domain}";
          redisCreateLocally = true; # Needed for Rate-Limit & bot protection
          configureNginx = true;
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
                "192.168.0.0/16"
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
      };
    };
}
