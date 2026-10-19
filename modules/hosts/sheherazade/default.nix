{ den, inputs, ... }: {
  den = {
    hosts.aarch64-linux.sheherazade = {
      instantiate =
        { modules, ... }:
        inputs.nixos-raspberrypi.lib.nixosSystem {
          inherit modules;
          # Already taken care of
          trustCaches = false;
        };

      users.kg.isAdmin = true;

      isServer = true;

      settings.static-ip = {
        v4 = "bogus";
        v6 = "bogus";
      };
    };

    aspects.sheherazade = {
      includes = with den.aspects; [
        rtc
        fs._.rpi._.ext4
      ];
      nixos = {
        imports = [ inputs.nixos-raspberrypi.nixosModules.raspberry-pi-4.base ];

        boot.loader.raspberry-pi.bootloader = "kernel";
      };
    };
  };
}
