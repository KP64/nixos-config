{
  den.aspects.mahdi.nixos =
    { config, lib, ... }:
    let
      domain = "navidrome.${config.networking.domain}";
      inherit (config.lib.securityHeader) mkCSP;
    in
    lib.mkMerge [
      (lib.mkIf config.services.navidrome.enable {
        sops = {
          secrets."navidrome/encryption-key" = { };
          templates."navidrome.env" = {
            restartUnits = [ config.systemd.services.navidrome.name ];
            owner = config.users.users.navidrome.name;
            content = ''
              ND_PASSWORDENCRYPTIONKEY=${config.sops.placeholder."navidrome/encryption-key"}
            '';
          };
        };

        services.caddy.virtualHosts.${domain}.extraConfig =
          let
            inherit (config.services.navidrome.settings) Address Port;
          in
          # caddy
          ''
            handle /oauth2/* {
                reverse_proxy https://oauth2-proxy.${config.networking.domain} {
                    header_up X-Real-IP {remote_host}
                    header_up X-Forwarded-Uri {uri}
                }
            }

            handle {
                forward_auth https://oauth2-proxy.${config.networking.domain} {
                    uri /oauth2/auth?allowed_groups=access_navidrome

                    header_up X-Real-IP {remote_host}

                    copy_headers X-Auth-Request-User X-Auth-Request-Email

                    @error status 401
                    handle_response @error {
                        redir * /oauth2/sign_in?rd={scheme}://{host}{uri}
                    }
                }
                reverse_proxy http://${Address}:${toString Port}
            }
            header {
                Strict-Transport-Security "max-age=31536000; includeSubDomains"
                Cross-Origin-Embedder-Policy require-corp
                Cross-Origin-Opener-Policy same-origin
                Cross-Origin-Resource-Policy same-origin
                Content-Security-Policy "${
                  mkCSP {
                    default-src = "self";
                    img-src = [
                      "self"
                      "blob:"
                      "data:"
                    ];
                    style-src = [
                      "self"
                      "unsafe-inline"
                    ];
                    script-src = [
                      "self"
                      "unsafe-inline"
                    ];
                  }
                }"
            }
          '';
      })
      {
        services.navidrome = {
          enable = true;
          environmentFile = config.sops.templates."navidrome.env".path;
          settings = {
            Address = "[::1]";
            BaseUrl = "https://${domain}";
            SearchFullString = true;
            EnableSharing = true;
          };
        };
      }
    ];
}
