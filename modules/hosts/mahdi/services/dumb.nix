toplevel: {
  flake.aspects.hosts-mahdi.nixos =
    { config, lib, ... }:
    let
      inherit (config.lib.nginx) mkPP;
    in
    {
      imports = [ toplevel.config.flake.modules.nixos.dumb ];

      services = {
        nginx.virtualHosts."dumb.${config.networking.domain}" = lib.mkIf config.services.dumb.enable {
          enableACME = true;
          acmeRoot = null;
          onlySSL = true;
          kTLS = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.dumb.port}";
            extraConfig = # nginx
              ''
                add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
                add_header X-Frame-Options SAMEORIGIN always;
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

        dumb.enable = true;
      };
    };
}
