{ den, inputs, ... }:
let
  inherit (inputs) nixos-raspberrypi;
in
{
  den = {
    hosts.aarch64-linux.morgiana = {
      instantiate =
        { modules, ... }:
        inputs.nixpkgs.lib.nixosSystem {
          inherit modules;
          specialArgs = { inherit nixos-raspberrypi; };
        };

      users.kg = { };
    };

    aspects.morgiana = {
      includes = with den.aspects; [
        auto-timezone
        antivirus
        rpi._.cache
        rpi._.rtc
        rpi._.fs._ext4
        ssh
        time
      ];
      nixos = { config, ... }: {
        imports = [
          inputs.nix-invisible.modules.nixos.host-morgiana
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

        sops.defaultSopsFile = ./secrets.yaml;
        users.users.root.password = config.sops.secrets.kg_password.path;
      };
    };
  };
}
