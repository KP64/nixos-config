toplevel@{ inputs, ... }:
{
  flake.modules.nixos.hosts-aladdin =
    { config, pkgs, ... }:
    {
      imports = [
        inputs.sops-nix.nixosModules.default
      ]
      ++ (with toplevel.config.flake.modules.nixos; [
        audio
        catppuccin
        desktop
        efi
        nix
        nvidia
        ssh
        sudo
        time
        tpm
        yubikey

        users-kg
      ]);

      system.stateVersion = "25.11";
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

      home-manager = {
        sharedModules = [
          {
            wayland.windowManager.hyprland.settings.monitorv2 = [
              {
                output = "DP-3";
                mode = "highrr";
                vrr = 2;
              }
              {
                output = "HDMI-A-1";
                mode = "preferred";
                position = "1920x500";
              }
            ];
          }
          (
            { config, ... }:
            {
              programs.niri.settings.outputs =
                let
                  cfg = config.programs.niri.settings.outputs;
                in
                {
                  DP-3 = {
                    focus-at-startup = true;
                    variable-refresh-rate = "on-demand";
                    position.x = 0;
                    position.y = 0;
                    mode = {
                      width = 1920;
                      height = 1080;
                      refresh = 239.757;
                    };
                  };
                  HDMI-A-1 = {
                    position.x = cfg.DP-3.mode.width;
                    position.y = 500;
                  };
                };
            }
          )
        ];
        users.kg = {
          imports = with toplevel.config.flake.modules.homeManager; [
            users-kg-firefox
            users-kg-glance
            users-kg-anki
            users-kg-kitty
            users-kg-niri
            users-kg-noctalia-shell
            users-kg-rofi
            users-kg-thunderbird
            users-kg-vesktop
          ];
          home = { inherit (config.system) stateVersion; };
        };
      };

      sops.defaultSopsFile = ./secrets.yaml;

      users.users.root.hashedPasswordFile = config.sops.secrets.kg_password.path;

      programs = {
        ausweisapp = {
          enable = true;
          openFirewall = true;
        };
        localsend.enable = true;
        obs-studio = {
          enable = true;
          enableVirtualCamera = true;
        };
      };
    };
}
