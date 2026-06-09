{ den, inputs, ... }: {
  # TODO: TOR Redirection links.
  #        - When someone visits one of my websites via TOR, that is available
  #          via an .onion address let crowdsec TOR Blocklist redirect to a
  #          static Website that tells them all services with the respective onion address.
  # TODO: Set CORS and other Security related stuff for Services
  den = {
    hosts.x86_64-linux.mahdi.users.kg = { };

    aspects.mahdi = {
      includes = with den.aspects; [
        antivirus
        auto-timezone
        catppuccin
        boot._.efi
        rpi._.cache
        ssh
        time
        nvidia._.cache
      ];

      nixos = { config, ... }: {
        imports = [ inputs.nix-invisible.modules.nixos.host-mahdi ];

        home-manager.users.kg.home = { inherit (config.system) stateVersion; };

        sops.defaultSopsFile = ./secrets.yaml;
        users.users.root.hashedPasswordFile = config.sops.secrets.kg_password.path;

        system.stateVersion = "26.05";
        hardware.facter.reportPath = ./facter.json;

        console.keyMap = config.services.xserver.xkb.layout;

        boot.binfmt = {
          preferStaticEmulators = true;
          emulatedSystems = [ "aarch64-linux" ];
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
    };
  };
}
