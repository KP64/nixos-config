toplevel@{ inputs, ... }:
{
  flake.modules.nixos.hosts-zarqa =
    { config, ... }:
    let
      inherit (inputs) nixos-raspberrypi;
    in
    {
      imports =
        (with inputs; [
          sops-nix.nixosModules.default
          nix-invisible.modules.nixos.host-mahdi
        ])
        ++ (with nixos-raspberrypi.lib; [
          inject-overlays
          inject-overlays-global
        ])
        ++ (with nixos-raspberrypi.nixosModules; [
          trusted-nix-caches
          nixpkgs-rpi

          raspberry-pi-3.base
        ])
        ++ (with toplevel.config.flake.modules.nixos; [
          nix
          rpi-cache
          ssh
          sudo
          time

          users-kg
        ]);

      # TODO: Enable once RTC is installed
      # Is needed for RTC.
      # hardware.i2c.enable = true;
      # environment.systemPackages = [ pkgs.i2c-tools ];

      home-manager.users.kg.home = { inherit (config.system) stateVersion; };

      system.stateVersion = "26.05";
      hardware.facter.reportPath = ./facter.json;

      console.keyMap = "de";

      sops.defaultSopsFile = ./secrets.yaml;

      users.users.root.hashedPasswordFile = config.sops.secrets.kg_password.path;
    };
}
