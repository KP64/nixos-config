toplevel@{ inputs, ... }:
{
  den = {
    hosts.aarch64-linux.zarqa.users.kg.classes = [ "homeManager" ];

    aspects.zarqa.nixos =
      { config, ... }:
      let
        inherit (inputs) nixos-raspberrypi;
      in
      {
        imports = [
          inputs.nix-invisible.modules.nixos.host-zarqa
        ]
        ++ (with nixos-raspberrypi.lib; [
          inject-overlays
          inject-overlays-global
        ])
        ++ (with nixos-raspberrypi.nixosModules; [
          nixpkgs-rpi
          raspberry-pi-3.base
        ])
        ++ (with toplevel.config.flake.modules.nixos; [
          nix
          rpi-cache
          rpi-rtc
          ssh
          time
        ]);

        home-manager.users.kg.home = { inherit (config.system) stateVersion; };

        system.stateVersion = "26.05";
        hardware.facter.reportPath = ./facter.json;

        console.keyMap = "de";

        sops.defaultSopsFile = ./secrets.yaml;
        users.users.root.hashedPasswordFile = config.sops.secrets.kg_password.path;
      };
  };
}
