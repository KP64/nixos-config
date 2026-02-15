{
  flake.aspects.hosts-mahdi.nixos =
    { config, lib, ... }:
    let
      inherit (config.lib.nginx) mkCSP mkPP;
    in
    {
      services = {
        nginx.virtualHosts."anki.${config.networking.domain}" =
          lib.mkIf config.services.anki-sync-server.enable
            {
              enableACME = true;
              acmeRoot = null;
              onlySSL = true;
              kTLS = true;
              locations."/" = {
                proxyPass = "http://[${config.services.anki-sync-server.address}]:${toString config.services.anki-sync-server.port}";
                extraConfig = # nginx
                  ''
                    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
                    add_header Content-Security-Policy "${mkCSP { default-src = "none"; }}" always;
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

        # NOTE: When using AnkiDroid remember that you need to insert the username
        #       and not the email as instructed. Unless the username is an email ofc...
        anki-sync-server = {
          enable = true;
          users = config.lib.anki.genUsers;
        };
      };
    };
}
