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
          services.caddy = {
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
                          Strict-Transport-Security "max-age=31536000; includeSubDomains"
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
                (lib.mkIf mahdi.config.services.caddy.enable (
                  proxyServices mahdi.config.staticIPv6 mahdi.config.services.caddy.virtualHosts
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
