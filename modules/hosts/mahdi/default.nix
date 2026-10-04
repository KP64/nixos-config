{ den, ... }: {
  den = {
    hosts.x86_64-linux.mahdi = {
      isServer = true;

      users.kg = { };
    };

    aspects.mahdi = {
      includes = with den.aspects; [
        antivirus
        catppuccin
        boot._.efi
        rpi._.cache
        ssh
        time
        nvidia._.cache
      ];

      nixos = { config, pkgs, ... }: {
        home-manager.users.kg.home = { inherit (config.system) stateVersion; };

        sops.defaultSopsFile = ./secrets.yaml;
        users.users.root.hashedPasswordFile = config.sops.secrets.kg_password.path;

        system.stateVersion = "26.11";
        hardware.facter.reportPath = ./facter.json;

        boot = {
          kernelPackages = pkgs.linuxPackages_latest;
          binfmt.emulatedSystems = [ "aarch64-linux" ];
        };
      };
    };
  };
}
