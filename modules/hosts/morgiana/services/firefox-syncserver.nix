{
  den.aspects.morgiana.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    lib.mkMerge [
      (lib.mkIf config.services.firefox-syncserver.enable {
        sops = {
          secrets = {
            "firefox-sync/master" = { };
            "firefox-sync/metrics" = { };
          };
          templates."firefox-syncserver.env" = {
            restartUnits = [ config.systemd.services.firefox-syncserver.name ];
            content = ''
              SYNC_MASTER_SECRET=${config.sops.placeholder."firefox-sync/master"}
              SYNC_TOKENSERVER__FXA_METRICS_HASH_SECRET=${config.sops.placeholder."firefox-sync/metrics"}
            '';
          };
        };
        services = {
          mysql.package = pkgs.mariadb;

          caddy.virtualHosts.${config.services.firefox-syncserver.singleNode.hostname}.extraConfig = # caddy
            ''
              reverse_proxy http://127.0.0.1:${toString config.services.firefox-syncserver.settings.port}
            '';
        };
      })
      {
        services.firefox-syncserver = {
          enable = true;
          # TODO: Remove this once https://github.com/NixOS/nixpkgs/issues/540669 is closed
          package = pkgs.syncstorage-rs.overrideAttrs (
            _:
            let
              swaggerSrc = pkgs.fetchurl {
                url = "https://github.com/swagger-api/swagger-ui/archive/refs/tags/v5.17.14.zip";
                hash = "sha256-SBJE0IEgl7Efuu73n3HZQrFxYX+cn5UU5jrL4T5xzNw=";
              };

              src = pkgs.fetchFromGitHub {
                owner = "mozilla-services";
                repo = "syncstorage-rs";
                rev = "f084c3c78f91939a69ff10303f6579f7bf538beb";
                hash = "sha256-d0rA/bWuo4gXvqI2inlvRI9NBP6ZRNSwLPkszNIkmhE=";
              };
            in
            {
              inherit src;
              version = "0.23.3";
              cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
                inherit src;
                hash = "sha256-BJ5+6o57WlwsTerKCmOPXATPHQfjr5cRYMbqC8CIPg0=";
              };
              env.SWAGGER_UI_DOWNLOAD_URL = "file://${swaggerSrc}";
            }
          );
          secrets = config.sops.templates."firefox-syncserver.env".path;
          singleNode = {
            enable = true;
            hostname = "firefox-sync.${config.networking.domain}";
            enableTLS = true;
          };
        };
      }
    ];
}
