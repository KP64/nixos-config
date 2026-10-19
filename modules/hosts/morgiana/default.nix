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
      settings.static-ip.v6 = "bogus";
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
