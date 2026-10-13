{ den, inputs, ... }:
let
  inherit (inputs) nixos-raspberrypi;
in
{
  den = {
    hosts.aarch64-linux.sheherazade = {
      instantiate =
        { modules, ... }:
        inputs.nixpkgs.lib.nixosSystem {
          inherit modules;
          specialArgs = { inherit nixos-raspberrypi; };
        };

      isServer = true;

      users.kg = { };
    };

    aspects.sheherazade = {
      includes = with den.aspects; [
        rpi._.cache
        rpi._.rtc
        rpi._.fs._ext4
        ssh
        time
      ];
      nixos = {
        imports = [
          nixos-raspberrypi.lib.inject-overlays
        ]
        ++ (with nixos-raspberrypi.nixosModules; [
          nixpkgs-rpi
          raspberry-pi-4.base
        ]);

        boot.loader.raspberry-pi.bootloader = "kernel";
      };
    };
  };
}
