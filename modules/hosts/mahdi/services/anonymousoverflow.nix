toplevel: {
  flake.modules.nixos.hosts-mahdi =
    { config, lib, ... }:
    let
      inherit (config.lib.nginx) mkCSP mkPP;
    in
    {
      imports = [ toplevel.config.flake.modules.nixos.anonymousoverflow ];

      config = lib.mkMerge [
        (lib.mkIf config.services.anonymousoverflow.enable {
          sops.secrets."anonymousoverflow.env" = { };

          services.nginx.virtualHosts."overflow.${config.networking.domain}" = {
            enableACME = true;
            acmeRoot = null;
            onlySSL = true;
            kTLS = true;
            locations."/" = {
              proxyPass = "http://${config.services.anonymousoverflow.host}:${toString config.services.anonymousoverflow.port}";
              extraConfig = # nginx
                ''
                  add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
                  add_header Content-Security-Policy "${
                    mkCSP {
                      default-src = "none";
                      style-src = "self";
                      img-src = "self";
                      font-src = "self";
                      script-src = "self";
                    }
                  }" always;
                  add_header Referrer-Policy no-referrer always;
                  add_header Permissions-Policy "${
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
                  }" always;
                '';
            };
          };
        })
        {
          services.anonymousoverflow = {
            enable = true;
            appUrl = "https://overflow.${config.networking.domain}";
            environmentFile = config.sops.secrets."anonymousoverflow.env".path;
          };
        }
      ];
    };
}
