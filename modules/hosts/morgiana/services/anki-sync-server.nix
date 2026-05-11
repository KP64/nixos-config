{
  den.aspects.morgiana.nixos =
    { config, lib, ... }:
    let
      inherit (config.lib.securityHeader) mkCSP mkPP;
    in
    {
      services = {
        caddy.virtualHosts."anki.${config.networking.domain}" =
          lib.mkIf config.services.anki-sync-server.enable
            {
              extraConfig = # caddy
                ''
                  reverse_proxy http://[${config.services.anki-sync-server.address}]:${toString config.services.anki-sync-server.port}
                  header {
                      Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
                      Content-Security-Policy "${mkCSP { default-src = "none"; }}"
                      X-Frame-Options SAMEORIGIN
                      X-Content-Type-Options nosniff
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
                  }
                '';
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
