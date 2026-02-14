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
          users-kg-vesktop
        ];
        home = { inherit (config.system) stateVersion; };
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
