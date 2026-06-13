toplevel@{ den, ... }:
{
  den.aspects.zarqa = {
    includes = [ den.aspects.secrets._.porkbun ];

    nixos =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        sops = lib.mkIf config.services.caddy.enable {
          templates."caddy.env" = {
            owner = config.services.caddy.user;
            restartUnits = [ config.systemd.services.caddy.name ];
            content = ''
              PORKBUN_API_KEY=${config.sops.placeholder."porkbun/api_key"}
              PORKBUN_SECRET_API_KEY=${config.sops.placeholder."porkbun/secret_api_key"}
            '';
          };
        };

        services.caddy = {
          enable = true;
          package = pkgs.caddy.withPlugins {
            plugins = [ "github.com/caddy-dns/porkbun@v0.3.1" ];
            hash = "sha256-MlKX2obWac+jP4j9UHFMxsY/DRaqw9JCVAdI7erhFwo=";
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
              acme_dns porkbun {
                  api_key {env.PORKBUN_API_KEY}
                  api_secret_key {env.PORKBUN_SECRET_API_KEY}
              }
            '';
          virtualHosts =
            let
              inherit (toplevel.config.flake.nixosConfigurations) mahdi morgiana;

              proxyServices =
                ipv6: vhosts:
                vhosts
                |> lib.filterAttrs (n: _: lib.hasSuffix ".${config.networking.domain}" n)
                |> lib.mapAttrs' (
                  vhostDomain: _: {
                    name = vhostDomain;
                    value.extraConfig = # caddy
                      ''
                        reverse_proxy https://[${ipv6}] {
                            transport http {
                                tls_server_name ${vhostDomain}
                            }
                        }
                      '';
                  }
                );
            in
            lib.mkMerge [
              (lib.mkIf mahdi.config.services.nginx.enable (
                proxyServices mahdi.config.staticIPv6 mahdi.config.services.nginx.virtualHosts
              ))
              (lib.mkIf morgiana.config.services.caddy.enable (
                proxyServices morgiana.config.staticIPv6 morgiana.config.services.caddy.virtualHosts
              ))
            ];
        };
      };
  };
}
