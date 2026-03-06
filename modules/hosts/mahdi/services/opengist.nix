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

          services.nginx.virtualHosts.${domain} = {
            enableACME = true;
            acmeRoot = null;
            onlySSL = true;
            kTLS = true;
            locations."/" = {
              proxyPass = "http://unix:${config.services.opengist.settings."http.host"}";
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
            settings =
              let
                clientKey = "opengist";
              in
              {
                external-url = "https://${domain}";
                "ssh.port" = 2223;
                "oidc.provider-name" = "Kanidm";
                "oidc.client-key" = clientKey;
                "oidc.discovery-url" =
                  "${config.services.kanidm.server.settings.origin}/oauth2/openid/${clientKey}/.well-known/openid-configuration";
                "oidc.group-claim-name" = "groups";
                "oidc.admin-group" = "opengist.admins";
              };
          };
        }
      ];
    };
}
