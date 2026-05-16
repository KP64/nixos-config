{
  den.aspects.morgiana.nixos =
    { config, ... }:
    let
      inherit (config.lib.securityHeader) mkCSP mkPP;
    in
    {
      services.bentopdf = {
        enable = true;
        domain = "bentopdf.${config.networking.domain}";
        caddy = {
          enable = true;
          virtualHost.extraConfig = # caddy
            ''
              header {
                  Cross-Origin-Embedder-Policy "require-corp"
                  Cross-Origin-Opener-Policy "same-origin"
                  Cross-Origin-Resource-Policy "cross-origin"
                  Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
                  X-Frame-Options "SAMEORIGIN"
                  X-Content-Type-Options "nosniff"
                  Referrer-Policy no-referrer
                  Content-Security-Policy "${
                    mkCSP {
                      default-src = "none";
                      frame-src = "self";
                      script-src = [
                        "self"
                        "unsafe-inline"
                        "wasm-unsafe-eval"
                        "https://snippet.embedpdf.com"
                      ];
                      style-src = [
                        "self"
                        "unsafe-inline"
                      ];
                      connect-src = "self";
                      font-src = [
                        "self"
                        "data:"
                      ];
                      img-src = [
                        "self"
                        "data:"
                      ];
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
                      magnetometer = "()";
                      midi = "()";
                      serial = "()";
                      hid = "()";
                    }
                  }"
              }
            '';
        };
      };
    };
}
