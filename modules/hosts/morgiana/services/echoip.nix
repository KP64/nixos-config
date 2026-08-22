{
  den.aspects.morgiana.nixos =
    { config, lib, ... }:
    let
      inherit (config.lib.securityHeader) mkCSP mkPP;
    in
    {
      services = {
        caddy.virtualHosts."echoip.${config.networking.domain}" = lib.mkIf config.services.echoip.enable {
          extraConfig = # caddy
            ''
              reverse_proxy http://${config.services.echoip.listenAddress}
              header {
                  Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
                  Content-Security-Policy "${
                    mkCSP {
                      default-src = "none";
                      style-src-elem = "unsafe-inline";
                      img-src = "self";
                    }
                  }"
                  X-Frame-Options DENY
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
                  Cross-Origin-Embedder-Policy require-corp
                  Cross-Origin-Opener-Policy same-origin
                  Cross-Origin-Resource-Policy same-origin
              }
            '';
        };

        echoip = {
          enable = true;
          listenAddress = "[::1]:8000";
          enablePortLookup = true;
          enableReverseHostnameLookups = true;
          remoteIpHeader = "X-Forwarded-For";
        };
      };
    };
}
