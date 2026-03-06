toplevel: {
  flake.modules.nixos.hosts-mahdi =
    { config, lib, ... }:
    let
      domain = "opengist.${config.networking.domain}";
      inherit (config.lib.nginx) mkCSP mkPP;
    in
    {
      imports = [ toplevel.config.flake.modules.nixos.opengist ];

      config = lib.mkMerge [
        (lib.mkIf config.services.opengist.enable {
          sops.secrets."opengist.env" = { };

          networking.firewall.allowedTCPPorts = [ config.services.opengist.environment.OG_SSH_PORT ];

          services.nginx.virtualHosts.${domain} = {
            enableACME = true;
            acmeRoot = null;
            onlySSL = true;
            kTLS = true;
            locations."/" = {
              proxyPass = "http://unix:${config.services.opengist.environment.OG_HTTP_HOST}";
              extraConfig = # nginx
                ''
                  add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
                  add_header Referrer-Policy no-referrer always;
                  add_header Content-Security-Policy "${
                    mkCSP {
                      default-src = "none";
                      connect-src = "self";
                      img-src = [
                        "self"
                        "https://www.gravatar.com"
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
                      font-src = "self";
                    }
                  }";
                  add_header Permissions-Policy "${
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
                  }" always;
                '';
            };
          };
        })
        {
          services.opengist = {
            enable = true;
            environmentFile = config.sops.secrets."opengist.env".path;
            environment =
              let
                OG_OIDC_CLIENT_KEY = "opengist";
              in
              {
                OG_EXTERNAL_URL = "https://${domain}";
                OG_SSH_PORT = 2223;
                OG_OIDC_PROVIDER_NAME = "Kanidm";
                inherit OG_OIDC_CLIENT_KEY;
                OG_OIDC_DISCOVERY_URL = "${config.services.kanidm.server.settings.origin}/oauth2/openid/${OG_OIDC_CLIENT_KEY}/.well-known/openid-configuration";
                OG_OIDC_GROUP_CLAIM_NAME = "groups";
                OG_OIDC_ADMIN_GROUP = "opengist.admins";
              };
          };
        }
      ];
    };
}
