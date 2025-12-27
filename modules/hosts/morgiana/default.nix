toplevel@{ inputs, ... }:
{

  # Pi4b
  flake.modules.nixos.hosts-morgiana =
    let
      inherit (inputs) nixos-raspberrypi;
    in
    {
      imports = [
        inputs.sops-nix.nixosModules.default
      ]
      ++ (with nixos-raspberrypi.lib; [
        inject-overlays
        inject-overlays-global
      ])
      ++ (with nixos-raspberrypi.nixosModules; [
        trusted-nix-caches
        nixpkgs-rpi
        usb-gadget-ethernet

        raspberry-pi-4.base
      ])
      ++ (with toplevel.config.flake.modules.nixos; [
        catppuccin
        nix
        ssh
        sudo
        time

        users-kg
      ]);

      system.stateVersion = "26.05";
      time.timeZone = "Europe/Berlin";
      console.keyMap = "de";

      users.users.root.password = "12345";
    };
}
