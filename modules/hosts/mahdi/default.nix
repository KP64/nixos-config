toplevel@{ inputs, ... }:
{
  # TODO: TOR Redirection links.
  #        - When someone visits one of my websites via TOR, that is available
  #          via an .onion address let crowdsec TOR Blocklist redirect to a
  #          static Website that tells them all services with the respective onion address.
  # TODO: Systemd Service Hardening
  flake.aspects.hosts-mahdi.nixos =
    { config, ... }:
    {
      imports =
        (with inputs; [
          sops-nix.nixosModules.default
          nix-invisible.modules.nixos.host-mahdi
        ])
        ++ (with toplevel.config.flake.modules.nixos; [
          catppuccin
          efi
          nix
          ssh
          sudo
          time

          users-kg
        ]);

      home-manager.users.kg.home = { inherit (config.system) stateVersion; };

      sops.defaultSopsFile = ./secrets.yaml;
      users.users.root.hashedPasswordFile = config.sops.secrets.kg_password.path;

      system.stateVersion = "25.11";
      hardware.facter.reportPath = ./facter.json;

      console.keyMap = config.services.xserver.xkb.layout;

      boot = {
        # FIXME: iwlwifi kernel Module takes whole system down
        # kernelPackages = pkgs.linuxPackages-zen;
        binfmt = {
          preferStaticEmulators = true;
          emulatedSystems = [ "aarch64-linux" ];
        };
      };

      security = {
        lockKernelModules = true;
        protectKernelImage = true;
      };

      services = {
        xserver.xkb.layout = "de";
        # This service is the "only" way to
        # communicate with the TPM (v1.2) device
        tcsd.enable = true;
        # Firmware is locked
        fwupd.enable = false;
      };
    };
}
