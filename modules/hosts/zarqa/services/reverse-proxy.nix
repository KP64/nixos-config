toplevel@{ den, ... }:
{
  den.aspects.zarqa = {
    includes = with den.aspects; [
      secrets._.porkbun
      dyndns
    ];

    nixos =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        inherit (toplevel.config.flake.nixosConfigurations) mahdi morgiana;
        torORPort = builtins.head morgiana.config.services.tor.settings.ORPort;
        forgejoSSHPort = mahdi.config.services.forgejo.settings.server.SSH_PORT;
        inherit (mahdi.config.services.opengist.environment) OG_SSH_PORT;
        ntsPort = 4460;
        minecraftPort = 25565;
      in
      lib.mkMerge [
        (lib.mkIf config.services.caddy.enable {
          sops.templates."caddy.env" = {
            owner = config.services.caddy.user;
            restartUnits = [ config.systemd.services.caddy.name ];
            content = ''
              PORKBUN_API_KEY=${config.sops.placeholder."porkbun/api_key"}
              PORKBUN_SECRET_API_KEY=${config.sops.placeholder."porkbun/secret_api_key"}
            '';
          };

          services.oink.domains = [
            { inherit (config.networking) domain; }
            {
              inherit (config.networking) domain;
              subdomain = "*";
            }
          ];
        })
        {
          networking.firewall.allowedTCPPorts = [
            torORPort
            ntsPort
            forgejoSSHPort
            OG_SSH_PORT
            minecraftPort
          ];
          services.haproxy = {
            enable = true;
            config = ''
              global
                ssl-mode-async
                # TODO: Enable this
                # zero-warning

                harden.reject-privileged-ports.tcp on
                harden.reject-privileged-ports.quic on

                httpclient.ssl.verify required
                ssl-default-bind-options force-tlsv13

              defaults
                mode tcp
                option tcplog
                option dontlognull
                option clitcpka
                option srvtcpka

              frontend tor-in
                bind [::]:${toString torORPort} v4v6
                default_backend tor-out
              backend tor-out
                server tor [${morgiana.config.staticIPv6}]:${toString torORPort} check

              frontend nts-in
                bind [::]:${toString ntsPort} v4v6
                default_backend nts-out
              backend nts-out
                server nts [${morgiana.config.staticIPv6}]:${toString ntsPort} check

              frontend forgejo-in
                bind [::]:${toString forgejoSSHPort} v4v6
                default_backend forgejo-out
              backend forgejo-out
                server forgejo [${mahdi.config.staticIPv6}]:${toString forgejoSSHPort} check

              frontend opengist-in
                bind [::]:${toString OG_SSH_PORT} v4v6
                default_backend opengist-out
              backend opengist-out
                server opengist [${mahdi.config.staticIPv6}]:${toString OG_SSH_PORT} check

              frontend minecraft-in
                bind [::]:${toString minecraftPort} v4v6
                default_backend minecraft-out
              backend minecraft-out
                server minecraft [${mahdi.config.staticIPv6}]:${toString minecraftPort} check
            '';
          };

          services.caddy = {
            enable = true;
            package = pkgs.caddy.withPlugins {
              plugins = [ "github.com/caddy-dns/porkbun@v0.3.1" ];
              hash = "sha256-JtzeWz9GdW/+1Qft5nU9diPkFQvPGxQkgR8n8w+ryoI=";
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
                  |> builtins.mapAttrs (
                    vhostDomain: _: {
                      extraConfig = # caddy
                        ''
                          reverse_proxy https://[${ipv6}] {
                              header_up Host {host}
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
        }
      ];
  };
}
