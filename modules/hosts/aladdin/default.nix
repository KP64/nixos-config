{ den, ... }: {
  den = {
    hosts.x86_64-linux.aladdin.users.kg = { };

    aspects.aladdin = {
      includes =
        (with den.aspects; [
          audio
          auto-timezone
          boot._.secure
          catppuccin
          desktop
          gaming._.steam
          gaming._.lutris
          nvidia
          obs-studio
          ssh
          time
          tpm
          yubikey
        ])
        ++ (with den.aspects.kg._; [
          firefox
          glance
          anki
          kitty
          niri
          noctalia-shell
          prismlauncher
          thunderbird
          ttyper
        ]);

      nixos = { config, pkgs, ... }: {
        system.stateVersion = "26.05";
        hardware = {
          facter.reportPath = ./facter.json;
          bluetooth.settings.General = {
            FastConnectable = true;
            Privacy = "network/on";
            SecureConnection = "only";
          };
        };

        console.keyMap = config.services.xserver.xkb.layout;
        services.xserver.xkb.layout = "de";
        boot = {
          kernelPackages = pkgs.linuxPackages_zen;
          measuredPcrs = [
            0
            4
            7
          ];
          binfmt = {
            preferStaticEmulators = true;
            emulatedSystems = [ "aarch64-linux" ];
          };
        };

        home-manager.users.kg.home = { inherit (config.system) stateVersion; };

        users.users.root.hashedPasswordFile = config.sops.secrets.kg_password.path;

        programs = {
          ausweisapp = {
            enable = true;
            openFirewall = true;
          };
          localsend = {
            enable = true;
            openFirewall = true;
          };
          thunar.enable = true;
        };
      };
    };
  };
}
