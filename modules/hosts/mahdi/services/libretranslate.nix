{
  flake.aspects.hosts-mahdi.nixos =
    { config, ... }:
    let
      inherit (config.lib.nginx) mkCSP mkPP;
    in
    {
      services = {
        nginx.virtualHosts.${config.services.libretranslate.domain} = {
          enableACME = true;
          acmeRoot = null;
          onlySSL = true;
          kTLS = true;
          # Mostly taken from official docs
          extraConfig = # nginx
            ''
              fastcgi_hide_header X-Powered-By;
              add_header X-Robots-Tag "none" always;
              add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
              add_header Content-Security-Policy "${
                mkCSP {
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
                mkPP {
                  camera = "()";
                  microphone = "()";
                  geolocation = "()";
                }
              }" always;
            '';
        };

        # NOTE: To manage API keys use the "ltmanage-keys" cli command.
        # TODO: Get rid of trademark warning
        libretranslate = {
          enable = true;
          port = 33305;
          domain = "libretranslate.${config.networking.domain}";
          configureNginx = true;
          updateModels = true;
          enableApiKeys = true;
        };
      };
    };
}
