toplevel: {
  den.aspects.morgiana.nixos =
    { config, lib, ... }:
    let
      inherit (config.lib.securityHeader) mkPP;
    in
    {
      imports = [ toplevel.config.flake.modules.nixos.dumb ];

      services = {
        caddy.virtualHosts."dumb.${config.networking.domain}" = lib.mkIf config.services.dumb.enable {
          extraConfig = # caddy
            ''
              reverse_proxy http://[::1]:${toString config.services.dumb.port}
              header {
                  Strict-Transport-Security "max-age=31536000; includeSubDomains"
                  X-Frame-Options DENY
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
                  Cross-Origin-Embedder-Policy require-corp
                  Cross-Origin-Opener-Policy same-origin
                  Cross-Origin-Resource-Policy same-origin
              }
            '';
        };
        dumb.enable = true;
      };
    };
}
