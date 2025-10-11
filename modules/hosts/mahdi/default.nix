toplevel@{ inputs, ... }:
{
  # TODO: Move all provisional service secrets to the users if needed.
  # TODO: From Reverse Proxy to Service should preferably be HTTPS too!
  flake.modules.nixos.hosts-mahdi =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports =
        (with inputs; [
          nixos-facter-modules.nixosModules.facter
          sops-nix.nixosModules.default
        ])
        ++ (with toplevel.config.flake.modules.nixos; [
          catppuccin
          efi
          nix
          ssh
          sudo

          users-kg
        ]);

      facter.reportPath = ./facter.json;
      system.stateVersion = "25.11";

      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "open-webui" ];

      time.timeZone = "Europe/Berlin";
      console.keyMap = "de";
      services.xserver.xkb.layout = "de";

      boot.kernelPackages = pkgs.linuxPackages_zen;

      system.etc.overlay.mutable = false;

      security = {
        lockKernelModules = true;
        protectKernelImage = true;
      };

      sops.defaultSopsFile = ./secrets.yaml;

      # This service is the "only" way to
      # communicate with the TPM (v1.2) device
      services.tcsd.enable = true;

      users.users.root = {
        isSystemUser = true;
        hashedPasswordFile = config.sops.secrets.kg_password.path;
      };
    };
}
