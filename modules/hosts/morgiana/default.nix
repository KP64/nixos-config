toplevel@{ den, inputs, ... }:
{
  # TODO: Remove this and add patch to upstream repo.
  flake-file.inputs.nixos-raspberrypi-no-console = {
    inherit (toplevel.config.flake-file.inputs.nixos-raspberrypi) type repo;
    owner = "KP64";
    inputs = {
      argononed.follows = "nixos-raspberrypi/argononed";
      flake-compat.follows = "nixos-raspberrypi/flake-compat";
      nixos-images.follows = "nixos-raspberrypi/nixos-images";
      nixpkgs.follows = "nixos-raspberrypi/nixpkgs";
    };
  };

  den = {
    hosts.aarch64-linux.morgiana = {
      instantiate =
        { modules, ... }:
        inputs.nixos-raspberrypi-no-console.lib.nixosSystem {
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
      ];
    };

    aspects.morgiana = {
      includes = [ den.aspects.fs._.rpi._.ext4 ];
      nixos = {
        imports = [ inputs.nixos-raspberrypi-no-console.nixosModules.raspberry-pi-4.base ];

        boot.loader.raspberry-pi.bootloader = "kernel";
      };
    };
  };
}
