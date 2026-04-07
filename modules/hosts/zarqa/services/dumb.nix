toplevel: {
  flake.modules.nixos.hosts-zarqa =
    { config, ... }:
    let
      inherit (config.lib.securityHeader) mkPP;
    in
    {
      imports = [ toplevel.config.flake.modules.nixos.dumb ];

      services = {
        caddy.virtualHosts."dumb.${config.networking.domain}".extraConfig = # caddy
          ''
            reverse_proxy http://[::1]:${toString config.services.dumb.port}

            header {
                Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
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
            }
          '';
        dumb.enable = true;
      };
    };
}
