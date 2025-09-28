toplevel@{ inputs, ... }:
{
  flake.modules.nixos.hosts-mahdi =
    { config, pkgs, ... }:
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

      time.timeZone = "Europe/Berlin";
      console.keyMap = "de";
      services.xserver.xkb.layout = "de";

      boot.kernelPackages = pkgs.linuxPackages_zen;

      sops = {
        defaultSopsFile = ./secrets.yaml;
        age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      };

      # This service is the "only" way to
      # communicate with the TPM (v1.2) device
      services.tcsd.enable = true;

      users.users.root = {
        isSystemUser = true;
        hashedPasswordFile = config.sops.secrets."users/kg/password".path;
      };
    };
}
