toplevel@{ inputs, ... }:
{
  # FIXME: TODO: Do NOT Reuse Passwords
  flake.modules.nixos.hosts-zarqa =
    { config, ... }:
    let
      inherit (inputs) nixos-raspberrypi;
    in
    {
      imports = [
        inputs.sops-nix.nixosModules.default
      ]
      ++ (with nixos-raspberrypi.lib; [
        inject-overlays
        # inject-overlays-global # TODO: Reenable? causes lots of rebuilds
      ])
      ++ (with nixos-raspberrypi.nixosModules; [
        trusted-nix-caches
        nixpkgs-rpi

        raspberry-pi-3.base
      ])
      ++ (with toplevel.config.flake.modules.nixos; [
        nix
        ssh
        sudo
        time

        users-kg
      ]);

      home-manager.users.kg.home = { inherit (config.system) stateVersion; };

      system.stateVersion = "26.05";
      hardware.facter.reportPath = ./facter.json;

      time.timeZone = "Europe/Berlin";
      console.keyMap = "de";

      sops.defaultSopsFile = ./secrets.yaml;

      users.users.root.hashedPasswordFile = config.sops.secrets.kg_password.path;

      documentation = {
        nixos.enable = false;
        doc.enable = false;
      };
    };
}
