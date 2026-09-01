toplevel@{ den, ... }:
{
  den.aspects.mahdi = {
    includes = [ den.aspects.secrets._.oauth ];
    nixos =
      { config, lib, ... }:
      let
        domain = "gist.${config.networking.domain}";
        inherit (config.lib.securityHeader) mkCSP mkPP;
      in
      {
        imports = [ toplevel.config.flake.modules.nixos.opengist ];

        config = lib.mkMerge [
          (lib.mkIf config.services.opengist.enable {
            sops.templates."opengist.env" = {
              restartUnits = [ config.systemd.services.opengist.name ];
              content = ''
                OG_OIDC_SECRET=${config.sops.placeholder."kanidm/oauth2/opengist"}
              '';
            };

            networking.firewall.allowedTCPPorts = [ config.services.opengist.environment.OG_SSH_PORT ];

            services.caddy.virtualHosts.${domain}.extraConfig = # caddy
              ''
                reverse_proxy unix/${config.services.opengist.environment.OG_HTTP_HOST}
                header {
                    Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
                    Referrer-Policy no-referrer
                    Content-Security-Policy "${
                      mkCSP {
                        default-src = "none";
                        connect-src = "self";
                        img-src = [
                          "self"
                          "https://www.gravatar.com"
                          "data:"
                          "blob:"
                        ];
                        font-src = "self";
                        style-src = [
                          "self"
                          "unsafe-inline"
                        ];
                        script-src = "self";
                        script-src-elem = [
                          "self"
                          "unsafe-hashes"
                          "unsafe-inline"
                        ];
                        script-src-attr = [
                          "unsafe-hashes"
                          "unsafe-inline"
                        ];
                      }
                    }"
                    Permissions-Policy "${
                      mkPP {
                        camera = "()";
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
                    Cross-Origin-Embedder-Policy credentialless
                    Cross-Origin-Opener-Policy same-origin
                    Cross-Origin-Resource-Policy same-origin
                }
              '';
          })
          {
            services.opengist = {
              enable = true;
              environmentFile = config.sops.templates."opengist.env".path;
              environment =
                let
                  OG_OIDC_CLIENT_KEY = "opengist";
                in
                {
                  OG_EXTERNAL_URL = "https://${domain}";
                  OG_SSH_PORT = 2223;
                  OG_OIDC_PROVIDER_NAME = "Kanidm";
                  inherit OG_OIDC_CLIENT_KEY;
                  OG_OIDC_DISCOVERY_URL = "${toplevel.config.flake.nixosConfigurations.sheherazade.config.services.kanidm.server.settings.origin}/oauth2/openid/${OG_OIDC_CLIENT_KEY}/.well-known/openid-configuration";
                  OG_OIDC_GROUP_CLAIM_NAME = "groups";
                  OG_OIDC_ADMIN_GROUP = "admins";
                };
            };
          }
        ];
      };
  };
}
