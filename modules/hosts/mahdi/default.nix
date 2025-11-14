toplevel@{ inputs, ... }:
{
  # TODO: From Reverse Proxy to Service should preferably be HTTPS too!
  # TODO: Systemd Service Hardening
  # FIXME: TODO: Disable caching from OAauth endpoints!
  flake.modules.nixos.hosts-mahdi =
    { config, lib, ... }:
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

      nixpkgs.config.allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "open-webui"
          "terraform" # Needed by Coder
        ];

      time.timeZone = "Europe/Berlin";
      console.keyMap = "de";
      services.xserver.xkb.layout = "de";

      # FIXME: iwlwifi kernel Module takes whole system down
      # boot.kernelPackages = pkgs.linuxPackages-zen;

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
