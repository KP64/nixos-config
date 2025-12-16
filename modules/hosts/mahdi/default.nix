toplevel@{ inputs, ... }:
{
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

        users-kg
      ]);

      system.stateVersion = "25.11";

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

      users.users.root.hashedPasswordFile = config.sops.secrets.kg_password.path;
    };
}
