toplevel@{ den, inputs, ... }:
let
  inherit (inputs) nixos-raspberrypi-no-console;
in
{
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
        inputs.nixpkgs.lib.nixosSystem {
          inherit modules;
          specialArgs.nixos-raspberrypi = nixos-raspberrypi-no-console;
        };

      users.kg = { };
    };

    aspects.morgiana = {
      includes = with den.aspects; [
        auto-timezone
        rpi._.cache
        rpi._.fs._ext4
        ssh
      ];
      nixos = { config, ... }: {
        imports = [
          nixos-raspberrypi-no-console.lib.inject-overlays
        ]
        ++ (with nixos-raspberrypi-no-console.nixosModules; [
          nixpkgs-rpi
          raspberry-pi-4.base
          raspberry-pi-4.display-vc4
        ]);

        boot.loader.raspberry-pi.bootloader = "kernel";

        home-manager.users.kg.home = { inherit (config.system) stateVersion; };

        system.stateVersion = "26.11";
        hardware.facter.reportPath = ./facter.json;

        console.keyMap = "de";

        sops.defaultSopsFile = ./secrets.yaml;
        users.users.root.password = config.sops.secrets.kg_password.path;
      };
    };
  };
}
