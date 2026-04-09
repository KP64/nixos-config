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
            mahdiCfg = toplevel.config.flake.nixosConfigurations.mahdi.config;
          in
          lib.mkIf mahdiCfg.services.nginx.enable (
            mahdiCfg.services.nginx.virtualHosts
            |> lib.filterAttrs (n: _: lib.hasSuffix ".${config.networking.domain}" n)
            |> lib.mapAttrs' (
              vhostDomain: _: {
                name = vhostDomain;
                value.extraConfig = # caddy
                  ''
                    reverse_proxy https://${vhostDomain}
                  '';
              }
            )
          );
      };
    };
}
