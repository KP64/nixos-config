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
        bluetooth
        catppuccin
        desktop
        efi
        nix
        nvidia
        ssh
        sudo
        tpm

        users-kg
      ]);

      home-manager.users.kg.imports = with toplevel.config.flake.modules.homeManager; [
        users-kg-firefox
        users-kg-glance
        users-kg-anki
        users-kg-hypridle
        users-kg-hyprland
        users-kg-hyprlock
        users-kg-hyprpanel
        users-kg-hyprpaper
        users-kg-kitty
        users-kg-rofi
        users-kg-vesktop
      ];

      programs.obs-studio = {
        enable = true;
        enableVirtualCamera = true;
      };

      hardware.bluetooth.settings.General = {
        FastConnectable = true;
        Privacy = "network/on";
        SecureConnection = "only";
      };

      system.stateVersion = "25.11";
      time.timeZone = "Europe/Berlin";
      console.keyMap = "de";
      services.xserver.xkb.layout = "de";

      boot.kernelPackages = pkgs.linuxPackages_zen;

      sops.defaultSopsFile = ./secrets.yaml;

      users.users.root = {
        isSystemUser = true;
        hashedPasswordFile = config.sops.secrets.kg_password.path;
      };

      programs = {
        ausweisapp = {
          enable = true;
          openFirewall = true;
        };
        localsend.enable = true;
      };
    };
}
