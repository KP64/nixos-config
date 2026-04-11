toplevel: {
  flake.modules.nixos.hosts-zarqa =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      sops.secrets = lib.mkIf config.services.caddy.enable {
        "caddy.env".owner = config.services.caddy.user;
      };

      services.caddy = {
        enable = true;
        package = pkgs.caddy.withPlugins {
          plugins = [ "github.com/caddy-dns/porkbun@v0.3.1" ];
          hash = "sha256-Pb27UcjTRfGCmcCAvSZtaXNPANyeH46MeCw3APPv9uI=";
        };

        inherit (config.invisible) email;
        httpPort = null;
        openFirewall = true;
        enableReload = false;
        environmentFile = config.sops.secrets."caddy.env".path;
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
              vhosts:
              vhosts
              |> lib.filterAttrs (n: _: lib.hasSuffix ".${config.networking.domain}" n)
              |> lib.mapAttrs' (
                vhostDomain: _: {
                  name = vhostDomain;
                  value.extraConfig = # caddy
                    ''
                      reverse_proxy https://${vhostDomain}
                    '';
                }
              );
          in
          lib.mkMerge [
            (lib.mkIf mahdi.config.services.nginx.enable (
              proxyServices mahdi.config.services.nginx.virtualHosts
            ))
            (lib.mkIf morgiana.config.services.caddy.enable (
              proxyServices morgiana.config.services.caddy.virtualHosts
            ))
          ];
      };
    };
}
