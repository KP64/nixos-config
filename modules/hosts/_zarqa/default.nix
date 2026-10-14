{ den, inputs, ... }:
let
  inherit (inputs) nixos-raspberrypi;
in
{
  den = {
    hosts.aarch64-linux.zarqa = {
      instantiate =
        { modules, ... }:
        inputs.nixpkgs.lib.nixosSystem {
          inherit modules;
          specialArgs = { inherit nixos-raspberrypi; };
        };

      users.kg.isAdmin = true;

      isServer = true;
    };

    aspects.zarqa = {
      includes = with den.aspects; [
        rpi._.cache
        rpi._.fs._ext4
      ];
      nixos = {
        imports = [
          nixos-raspberrypi.lib.inject-overlays
        ]
        ++ (with nixos-raspberrypi.nixosModules; [
          nixpkgs-rpi
          raspberry-pi-3.base
        ]);

        boot.loader.raspberry-pi.bootloader = "kernel";
      };
    };
  };
}
