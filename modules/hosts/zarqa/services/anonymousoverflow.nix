toplevel: {
  den.aspects.zarqa.nixos =
    { config, lib, ... }:
    let
      inherit (config.lib.securityHeader) mkCSP mkPP;
    in
    {
      imports = [ toplevel.config.flake.modules.nixos.anonymousoverflow ];

      config = lib.mkMerge [
        (lib.mkIf config.services.anonymousoverflow.enable {
          sops = {
            secrets."anonymousoverflow/jwt" = { };
            templates."anonymousoverflow.env" = {
              restartUnits = [ config.systemd.services.anonymousoverflow.name ];
              content = ''
                JWT_SIGNING_SECRET=${config.sops.placeholder."anonymousoverflow/jwt"}
              '';
            };
          };

          services.caddy.virtualHosts."overflow.${config.networking.domain}".extraConfig = # caddy
            ''
              reverse_proxy http://[::1]:${toString config.services.anonymousoverflow.port}
              header {
                  Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
                  Referrer-Policy no-referrer
                  Content-Security-Policy "${
                    mkCSP {
                      default-src = "none";
                      style-src = "self";
                      img-src = "self";
                      font-src = "self";
                      script-src = "self";
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
            '';
        })
        {
          services.anonymousoverflow = {
            enable = true;
            appUrl = "https://overflow.${config.networking.domain}";
            environmentFile = config.sops.templates."anonymousoverflow.env".path;
          };
        }
      ];
    };
}
