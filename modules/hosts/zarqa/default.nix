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

      users.kg = { };
    };

    aspects.zarqa = {
      includes = with den.aspects; [
        auto-timezone
        rpi._.cache
        rpi._.rtc
        rpi._.fs._ext4
        ssh
        time
      ];
      nixos = { config, ... }: {
        imports = [
          inputs.nix-invisible.modules.nixos.host-zarqa
          nixos-raspberrypi.lib.inject-overlays
        ]
        ++ (with nixos-raspberrypi.nixosModules; [
          nixpkgs-rpi
          raspberry-pi-3.base
        ]);

        home-manager.users.kg.home = { inherit (config.system) stateVersion; };

        system.stateVersion = "26.11";
        hardware.facter.reportPath = ./facter.json;

        console.keyMap = "de";

        sops.defaultSopsFile = ./secrets.yaml;
        users.users.root.hashedPasswordFile = config.sops.secrets.kg_password.path;
      };
    };
  };
}
