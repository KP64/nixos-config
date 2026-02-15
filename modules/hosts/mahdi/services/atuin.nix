{
  flake.aspects.hosts-mahdi.nixos =
    { config, ... }:
    let
      inherit (config.lib.nginx) mkCSP mkPP;
    in
    {
      services = {
        nginx.virtualHosts."atuin.${config.networking.domain}" = {
          enableACME = true;
          acmeRoot = null;
          onlySSL = true;
          kTLS = true;
          locations."/" = {
            proxyPass = "http://${config.services.atuin.host}:${toString config.services.atuin.port}";
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

        atuin = {
          enable = true;
          port = 33196;
          openRegistration = true;
        };
      };
    };
}
