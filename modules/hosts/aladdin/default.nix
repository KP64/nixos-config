toplevel@{ inputs, ... }:
{
  flake.modules.nixos.hosts-aladdin =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.sops-nix.nixosModules.default
      ]
      ++ (with toplevel.config.flake.modules.nixos; [
        audio
        catppuccin
        desktop
        nix
        nvidia
        ssh
        sudo
        time
        tpm
        yubikey

        secure-boot

        users-kg
      ]);

      # TODO: Reenable sddm once https://github.com/NixOS/nixpkgs/issues/496361 is fixed
      services = {
        displayManager.sddm.enable = lib.mkForce false;
        greetd = {
          enable = true;
          useTextGreeter = true;
          settings.default_session.command =
            let
              inherit (config.programs) niri hyprland;
            in
            "${lib.getExe pkgs.tuigreet} --time --cmd ${
              if niri.enable then
                "niri"
              else if hyprland.enable then
                "hyprland"
              else
                throw "My man. You've to enable at least one WM"
            }";
        };
      };

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

      home-manager.users.kg = {
        imports = with toplevel.config.flake.modules.homeManager; [
          users-kg-firefox
          users-kg-glance
          users-kg-anki
          users-kg-kitty
          users-kg-niri
          users-kg-noctalia-shell
          users-kg-prismlauncher
          users-kg-thunderbird
        ];
        home = { inherit (config.system) stateVersion; };
      };

      sops.defaultSopsFile = ./secrets.yaml;

      users.users.root.hashedPasswordFile = config.sops.secrets.kg_password.path;

      programs = {
        thunar.enable = true;
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
