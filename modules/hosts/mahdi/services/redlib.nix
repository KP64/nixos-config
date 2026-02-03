{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    let
      domain = "redlib.${config.networking.domain}";
      inherit (config.lib.nginx) mkPP;
    in
    {
      services = {
        nginx.virtualHosts.${domain} = {
          enableACME = true;
          acmeRoot = null;
          onlySSL = true;
          kTLS = true;
          locations."/" = {
            proxyPass = "http://${config.services.redlib.address}:${toString config.services.redlib.port}";
            extraConfig = # nginx
              ''
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

        redlib = {
          enable = true;
          address = "127.0.0.1";
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
