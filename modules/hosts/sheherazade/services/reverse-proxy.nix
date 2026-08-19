toplevel@{ den, ... }:
{
  den.aspects.sheherazade = {
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
        inherit (config.lib.securityHeader) mkCSP mkPP;

        inherit (toplevel.config.flake.nixosConfigurations) mahdi morgiana;
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
          # TODO: Find a better way for HAProxy
          networking.firewall.allowedTCPPorts = [
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
                zero-warning

                harden.reject-privileged-ports.tcp on
                harden.reject-privileged-ports.quic on

                httpclient.ssl.verify required
                ssl-default-bind-options force-tlsv13

              defaults
                mode tcp

                option clitcpka
                option srvtcpka

                timeout connect 10s
                timeout client 1h
                timeout server 1h

              frontend nts-in
                bind [::]:${toString ntsPort} v4v6
                timeout client 30s
                default_backend nts-out
              backend nts-out
                timeout server 30s
                server nts [${morgiana.config.staticIPv6}]:${toString ntsPort} check

              frontend forgejo-in
                bind [::]:${toString forgejoSSHPort} v4v6
                timeout client 5m
                default_backend forgejo-out
              backend forgejo-out
                timeout server 5m
                timeout tunnel 5m
                server forgejo [${mahdi.config.staticIPv6}]:${toString forgejoSSHPort} check

              frontend opengist-in
                bind [::]:${toString OG_SSH_PORT} v4v6
                timeout client 5m
                default_backend opengist-out
              backend opengist-out
                timeout server 5m
                timeout tunnel 5m
                server opengist [${mahdi.config.staticIPv6}]:${toString OG_SSH_PORT} check

              frontend minecraft-in
                bind [::]:${toString minecraftPort} v4v6
                timeout client 24h
                default_backend minecraft-out
              backend minecraft-out
                timeout server 24h
                timeout tunnel 24h
                server minecraft [${mahdi.config.staticIPv6}]:${toString minecraftPort} check
            '';
          };

          services.caddy = {
            enable = true;
            package = pkgs.caddy.withPlugins {
              plugins = [ "github.com/caddy-dns/porkbun@v0.3.1" ];
              hash = "sha256-CjL8dMdnsiawaPiQGRvL3he4Ydd3nIbQs6tBWMwUbaw=";
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
                dns porkbun {
                    api_key {env.PORKBUN_API_KEY}
                    api_secret_key {env.PORKBUN_SECRET_API_KEY}
                }
                ech ech.${config.networking.domain}
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
                {
                  ${config.networking.domain}.extraConfig = # caddy
                    ''
                      respond "Welcome to the space that serves You!"
                      header {
                          Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
                          Content-Security-Policy "${mkCSP { default-src = "none"; }}"
                          X-Frame-Options DENY
                          X-Content-Type-Options "nosniff"
                          Referrer-Policy no-referrer
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
                }
                {
                  "*.${config.networking.domain}".extraConfig = # caddy
                    ''
                      tls {
                          dns porkbun {
                              api_key {env.PORKBUN_API_KEY}
                              api_secret_key {env.PORKBUN_SECRET_API_KEY}
                          }
                      }
                    '';
                }
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
