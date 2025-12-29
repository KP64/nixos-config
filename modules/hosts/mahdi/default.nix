toplevel@{ inputs, ... }:
{
  # TODO: Utilize system.nixos.tags (https://search.nixos.org/options?channel=unstable&show=system.nixos.tags&query=system.nixos.tags)
  # TODO: TOR Redirection links.
  #        - When someone visits one of my websites via TOR, that is available
  #          via an .onion address let crowdsec TOR Blocklist redirect to a
  #          static Website that tells them all services with the respective onion address.
  # TODO: From Reverse Proxy to Service should preferably be HTTPS too!
  # TODO: Systemd Service Hardening
  # FIXME: TODO: Disable caching from OAauth endpoints!
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      imports = [
        inputs.sops-nix.nixosModules.default
      ]
      ++ (with toplevel.config.flake.modules.nixos; [
        catppuccin
        efi
        nix
        ssh
        sudo
        time

        users-kg
      ]);

      system.stateVersion = "25.11";
      hardware.facter.reportPath = ./facter.json;

      time.timeZone = "Europe/Berlin";
      console.keyMap = "de";
      services.xserver.xkb.layout = "de";

      # FIXME: iwlwifi kernel Module takes whole system down
      # boot.kernelPackages = pkgs.linuxPackages-zen;
      boot.binfmt = {
        preferStaticEmulators = true;
        emulatedSystems = [ "aarch64-linux" ];
      };

      security = {
        lockKernelModules = true;
        protectKernelImage = true;
      };

      sops.defaultSopsFile = ./secrets.yaml;

      # This service is the "only" way to
      # communicate with the TPM (v1.2) device
      services.tcsd.enable = true;

      users.users.root.hashedPasswordFile = config.sops.secrets.kg_password.path;
    };
}
