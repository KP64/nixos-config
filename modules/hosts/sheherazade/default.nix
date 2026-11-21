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

      usbguardCfg = [
        {
          id = "1d6b:0002";
          serial = "0000:01:00.0";
          name = "xHCI Host Controller";
          hash = "WLLK8WnDcOZsmC13ldzWRmahoyPD7Y+TLn1uJ4TB2GU=";
          parent-hash = "MvRvALwPgwJIPJ4ZsIUCR65FuMV4N8+5Xl/ZylmE9z4=";
          interfaces = [ "09:00:00" ];
          connect-type = "";
        }
        {
          id = "1d6b:0003";
          serial = "0000:01:00.0";
          name = "xHCI Host Controller";
          hash = "boAZgaZDmSJy5CZ+Sxb27+UaJ9oJP414lq7qslVjPig=";
          parent-hash = "MvRvALwPgwJIPJ4ZsIUCR65FuMV4N8+5Xl/ZylmE9z4=";
          interfaces = [ "09:00:00" ];
          connect-type = "";
        }
        {
          id = "2109:3431";
          serial = "";
          name = "USB2.0 Hub";
          hash = "/yzg/BjU0j0CTc2DYFSrSSr2JGwmQuhhAhpqcTsXZA4=";
          parent-hash = "WLLK8WnDcOZsmC13ldzWRmahoyPD7Y+TLn1uJ4TB2GU=";
          interfaces = [ "09:00:00" ];
          connect-type = "unknown";
        }
        {
          id = "04d9:0007";
          serial = "";
          name = "Raspberry Pi Internal Keyboard";
          hash = "01Nu7+UDcwDcAoBNZaQhjmKNFaqvaCK7d1aqSdZ0krU=";
          parent-hash = "/yzg/BjU0j0CTc2DYFSrSSr2JGwmQuhhAhpqcTsXZA4=";
          interfaces = [
            "03:01:01"
            "03:00:00"
          ];
          connect-type = "unknown";
        }
      ];
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
