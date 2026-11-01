{ den, inputs, ... }: {
  den = {
    hosts.aarch64-linux.zarqa = {
      instantiate =
        { modules, ... }:
        inputs.nixos-raspberrypi.lib.nixosSystem {
          inherit modules;
          # Already taken care of
          trustCaches = false;
        };

      users.kg.isAdmin = true;

      isServer = true;
    };

    aspects.zarqa = {
      includes = with den.aspects; [
        fs._.rpi._.ext4
        rtc
      ];
      nixos = {
        imports = [ inputs.nixos-raspberrypi.nixosModules.raspberry-pi-3.base ];

        boot.loader.raspberry-pi.bootloader = "kernel";
      };
    };
  };
}
