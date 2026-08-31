toplevel@{ moduleWithSystem, den, ... }:
{
  den.aspects.sheherazade = {
    includes = with den.aspects; [
      secrets._.porkbun
      dyndns
    ];

    nixos = moduleWithSystem (
      { system, ... }:
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
        (lib.mkIf config.services.oauth2-proxy.enable { sops.secrets."oauth2-proxy/cookie-secret" = { }; })
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
          services = {
            haproxy = {
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

            # TODO: Refactor everything about oauth2-proxy...
            oauth2-proxy =
              let
                inherit (config.services) kanidm;
                clientID = "oauth2-proxy";
              in
              {
                enable = true;

                extraConfig = {
                  code-challenge-method = "S256";
                  cookie-samesite = "strict";
                  whitelist-domain = [ ".${config.networking.domain}" ];
                };

                provider = "oidc";
                oidcIssuerUrl = "${kanidm.server.settings.origin}/oauth2/openid/${clientID}";
                inherit clientID;
                clientSecretFile = config.sops.secrets."kanidm/oauth2/oauth2-proxy".path;
                redirectURL = "https://oauth2-proxy.${config.networking.domain}/oauth2/callback";
                email.domains = [ "*" ];

                cookie = {
                  domain = ".${config.networking.domain}";
                  secretFile = config.sops.secrets."oauth2-proxy/cookie-secret".path;
                };
                setXauthrequest = true;
                passAccessToken = true;
                reverseProxy = true;
                trustedProxyIP = [
                  "127.0.0.0/8"
                  "::1/128"
                  toplevel.config.flake.topology.${system}.config.networks.home.cidrv6
                ];
              };

            caddy = {
              enable = true;
              package = pkgs.caddy.withPlugins {
                plugins = [ "github.com/caddy-dns/porkbun@v0.3.1" ];
                hash = "sha256-iFuoa6k2r3jUPazHHujhB4bBq3Fz0Mv0Tjsr+gxMYQQ=";
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
                    ipv6: vhosts: protectedSubDomains:
                    vhosts
                    |> builtins.mapAttrs (
                      vhostDomain: _: {
                        extraConfig = # caddy
                          let
                            subDomain = lib.removeSuffix ".${config.networking.domain}" vhostDomain;
                          in
                          if (builtins.elem subDomain protectedSubDomains) then
                            # caddy
                            ''
                              handle /oauth2/* {
                                  reverse_proxy ${config.services.oauth2-proxy.httpAddress} {
                                      header_up X-Real-IP {remote_host}
                                      header_up X-Forwarded-Uri {uri}
                                  }
                              }

                              handle {
                                  forward_auth ${config.services.oauth2-proxy.httpAddress} {
                                      uri /oauth2/auth?allowed_groups=access_${subDomain}

                                      header_up X-Real-IP {remote_host}

                                      copy_headers X-Auth-Request-User X-Auth-Request-Email

                                      @error status 401
                                      handle_response @error {
                                          redir * /oauth2/sign_in?rd={scheme}://{host}{uri}
                                      }
                                  }

                                  reverse_proxy https://[${ipv6}] {
                                      header_up Host {host}
                                      transport http {
                                          tls_server_name ${vhostDomain}
                                      }
                                  }
                              }
                            ''
                          # caddy
                          else
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
                    "oauth2-proxy.${config.networking.domain}".extraConfig = # caddy
                      ''
                        header {
                            Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
                            X-Frame-Options DENY
                            X-Content-Type-Options nosniff
                            Referrer-Policy no-referrer
                            Cross-Origin-Embedder-Policy require-corp
                            Cross-Origin-Opener-Policy same-origin
                            Cross-Origin-Resource-Policy same-origin
                            Content-Security-Policy "${
                              mkCSP {
                                default-src = "none";
                                img-src = "self";
                                style-src-elem = [
                                  "self"
                                  "unsafe-inline"
                                ];
                                script-src-elem = "unsafe-inline";
                              }
                            }"
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
                        reverse_proxy ${config.services.oauth2-proxy.httpAddress}
                      '';
                  }
                  {
                    ${config.networking.domain}.extraConfig = # caddy
                      ''
                        respond "Welcome to the space that serves You!"
                        header {
                            Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
                            Content-Security-Policy "${
                              mkCSP {
                                default-src = "none";
                                img-src = "self";
                              }
                            }"
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
                            Cross-Origin-Embedder-Policy require-corp
                            Cross-Origin-Opener-Policy same-origin
                            Cross-Origin-Resource-Policy same-origin
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
                      mahdi.config.OAuthProxyProtectedSubDomains
                  ))
                  (lib.mkIf morgiana.config.services.caddy.enable (
                    proxyServices morgiana.config.staticIPv6 morgiana.config.services.caddy.virtualHosts
                      morgiana.config.OAuthProxyProtectedSubDomains
                  ))
                ];
            };
          };
        }
      ]
    );
  };
}
