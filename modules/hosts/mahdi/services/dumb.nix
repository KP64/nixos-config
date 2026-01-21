toplevel@{ customLib, ... }:
{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      imports = [ toplevel.config.flake.modules.nixos.dumb ];

      services.nginx.virtualHosts."dumb.${config.networking.domain}" = {
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
      };

      services.dumb.enable = true;
    };
}
