{ customLib, ... }:
{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      services.nginx.virtualHosts.${config.services.libretranslate.domain} = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        extraConfig = # nginx
          ''
            add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
            add_header Content-Security-Policy "${
              customLib.nginx.mkCSP {
                default-src = "none";
                font-src = "self";
                img-src = "self";
                style-src = [
                  "self"
                  "unsafe-inline"
                ];
                script-src = [
                  "self"
                  "unsafe-inline"
                  "unsafe-eval"
                ];
                connect-src = "self";
              }
            }" always; 
            add_header X-Frame-Options SAMEORIGIN always;
            add_header X-Content-Type-Options nosniff always;
            add_header Referrer-Policy no-referrer always;
            add_header Permissions-Policy "${
              customLib.nginx.mkPP {
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

      # NOTE: To manage API keys use the "ltmanage-keys" cli command.
      # TODO: Get rid of trademark warning
      services.libretranslate = {
        enable = true;
        port = 33305;
        domain = "libretranslate.${config.networking.domain}";
        configureNginx = true;
        updateModels = true;
        enableApiKeys = true;
      };
    };
}
