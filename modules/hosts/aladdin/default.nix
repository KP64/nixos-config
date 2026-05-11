toplevel@{ den, ... }:
{
  den = {
    # TODO: Find a better way for this
    hosts.x86_64-linux.aladdin.users.kg.classes = [ "homeManager" ];

    aspects.aladdin = {
      includes = with den.aspects; [
        gaming
        tpm

        # TODO: Find a better way for this
        kg._.niri
      ];
      _.kg.includes = with den.aspects; [
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
          imports = with toplevel.config.flake.modules.nixos; [
            audio
            catppuccin
            desktop
            nix
            nvidia
            obs-studio
            ssh
            time
            yubikey

            secure-boot
          ];

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
