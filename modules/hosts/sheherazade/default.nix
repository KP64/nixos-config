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

      users.kg = { };
    };

    aspects.sheherazade = {
      includes = with den.aspects; [
        rpi._.cache
        ssh
        time
      ];
      nixos = { config, ... }: {
        imports = [
          nixos-raspberrypi.lib.inject-overlays
        ]
        ++ (with nixos-raspberrypi.nixosModules; [
          nixpkgs-rpi
          raspberry-pi-4.base
        ]);

        home-manager.users.kg.home = { inherit (config.system) stateVersion; };

        system.stateVersion = "26.05";
        hardware.facter.reportPath = ./facter.json;

        console.keyMap = "de";

        users.users.root.hashedPasswordFile = config.sops.secrets.kg_password.path;
      };
    };
  };
}
