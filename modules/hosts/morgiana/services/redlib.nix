{
  flake.modules.nixos.hosts-morgiana =
    { config, lib, ... }:
    let
      domain = "redlib.${config.networking.domain}";
      inherit (config.lib.securityHeader) mkPP;
    in
    {
      services = {
        caddy.virtualHosts.${domain} = lib.mkIf config.services.redlib.enable {
          extraConfig = # caddy
            ''
              reverse_proxy http://[::1]:${toString config.services.redlib.port}
              header {
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

        redlib = {
          enable = true;
          address = "[::1]";
          port = 41297;
          settings = {
            REDLIB_ROBOTS_DISABLE_INDEXING = true;
            REDLIB_ENABLE_RSS = true;
            REDLIB_FULL_URL = "https://${domain}";

            REDLIB_DEFAULT_BLUR_SPOILER = true;
            REDLIB_DEFAULT_SHOW_NSFW = true;
            REDLIB_DEFAULT_BLUR_NSFW = true;
          };
        };
      };
    };
}
