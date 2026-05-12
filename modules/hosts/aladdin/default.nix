{ den, ... }:
{
  den = {
    hosts.x86_64-linux.aladdin.users.kg = { };

    aspects.aladdin = {
      includes = with den.aspects; [
        audio
        auto-timezone
        catppuccin
        desktop
        gaming
        nvidia
        obs-studio
        secure-boot
        ssh
        time
        tpm
        yubikey

        kg._.firefox
        kg._.glance
        kg._.anki
        kg._.kitty
        kg._.niri
        kg._.noctalia-shell
        kg._.prismlauncher
        kg._.thunderbird
        kg._.ttyper
      ];

      nixos =
        { config, pkgs, ... }:
        {
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
            binfmt = {
              preferStaticEmulators = true;
              emulatedSystems = [ "aarch64-linux" ];
            };
          };

          home-manager.users.kg.home = { inherit (config.system) stateVersion; };

          sops.defaultSopsFile = ./secrets.yaml;

          users.users.root.hashedPasswordFile = config.sops.secrets.kg_password.path;

          # TODO: Secure the ports opened by localsend and ausweisapp
          programs =
            let
              inherit (config.lib.hm) anyHmUser;
            in
            {
              ausweisapp = {
                enable = true;
                openFirewall = true;
              };
              localsend.enable = true;
              thunar.enable = true;
              trippy.enable = anyHmUser (hmUserCfg: hmUserCfg.programs.trippy.enable);
            };
        };
    };
  };
}
