{ self, ... }: {
  den.aspects.morgiana.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      sops = lib.mkIf config.services.caddy.enable {
        secrets =
          let
            sopsFile = "${self}/secrets/porkbun.yaml";
          in
          {
            porkbun_api_key = {
              inherit sopsFile;
              key = "api_key";
            };
            porkbun_secret_api_key = {
              inherit sopsFile;
              key = "secret_api_key";
            };
          };
        templates."caddy.env" = {
          owner = config.services.caddy.user;
          restartUnits = [ config.systemd.services.caddy.name ];
          content = ''
            PORKBUN_API_KEY=${config.sops.placeholder.porkbun_api_key}
            PORKBUN_SECRET_API_KEY=${config.sops.placeholder.porkbun_secret_api_key}
          '';
        };
      };

      services.caddy = {
        enable = true;
        package = pkgs.caddy.withPlugins {
          plugins = [ "github.com/caddy-dns/porkbun@v0.3.1" ];
          hash = "sha256-BKUsUoBE1IjnD9Xu8kTVkbRqqk2qvNtFDD/pvVkfRmI=";
        };

        inherit (config.invisible) email;
        httpPort = null;
        openFirewall = true;
        enableReload = false;
        environmentFile = config.sops.templates."caddy.env".path;
        globalConfig = # caddy
          ''
            admin off
            persist_config off
            skip_install_trust
            default_bind ${config.staticIPv4} [${config.staticIPv6}]
            acme_dns porkbun {
                api_key {env.PORKBUN_API_KEY}
                api_secret_key {env.PORKBUN_SECRET_API_KEY}
            }
            servers {
                trusted_proxies static private_ranges
                trusted_proxies_strict
            }
          '';
      };
    };
}
