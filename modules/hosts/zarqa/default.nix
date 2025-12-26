toplevel@{ inputs, ... }:
{
  # TODO: Nix-topology. Names are getting unwieldy
  # FIXME: TODO: Do NOT Reuse Passwords
  # Pi3+
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

        users-kg
      ]);

      system.stateVersion = "26.05";
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
