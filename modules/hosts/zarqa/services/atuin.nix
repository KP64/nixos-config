{
  flake.modules.nixos.hosts-zarqa =
    { config, lib, ... }:
    let
      inherit (config.lib.securityHeader) mkCSP mkPP;
    in
    {
      services = {
        caddy.virtualHosts."atuin.${config.networking.domain}" = lib.mkIf config.services.atuin.enable {
          extraConfig = # caddy
            ''
              reverse_proxy http://[${config.services.atuin.host}]:${toString config.services.atuin.port}

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

        atuin = {
          enable = true;
          host = "::1";
          port = 33196;
          openRegistration = true;
        };
      };
    };
}
