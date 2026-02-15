{ inputs, ... }:
{
  flake.aspects.hosts-mahdi.nixos =
    { config, lib, ... }:
    let
      inherit (config.lib.nginx) mkCSP mkPP;
    in
    {
      imports = [ inputs.harmonia.nixosModules.harmonia ];

      config = lib.mkMerge [
        (lib.mkIf config.services.harmonia-dev.cache.enable {
          sops.secrets.harmonia-key = { };

          services.nginx.virtualHosts."cache.${config.networking.domain}" = {
            enableACME = true;
            acmeRoot = null;
            onlySSL = true;
            kTLS = true;
            locations."/" = {
              proxyPass = "http://${config.services.harmonia-dev.cache.settings.bind}";
              extraConfig = # nginx
                ''
                  add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
                  add_header Content-Security-Policy "${
                    mkCSP {
                      default-src = "none";
                      img-src = "self";
                      style-src = "unsafe-inline";
                    }
                  }" always;
                  add_header X-Frame-Options SAMEORIGIN always;
                  add_header X-Content-Type-Options nosniff always;
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
          services.harmonia-dev = {
            daemon.enable = true;
            cache = {
              enable = true;
              signKeyPaths = [ config.sops.secrets.harmonia-key.path ];
              settings.bind = "unix:/run/harmonia/harmonia.socket";
            };
          };
        }
      ];
    };
}
