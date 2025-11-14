toplevel@{ moduleWithSystem, inputs, ... }:
{
  flake.modules = {
    nixos.users-kg =
      { config, ... }:
      {
        home-manager.users.kg.imports = [ toplevel.config.flake.modules.homeManager.users-kg ];

        sops.secrets =
          let
            sopsFile = ./secrets.yaml;
          in
          {
            kg_password = {
              neededForUsers = true;
              key = "password";
              inherit sopsFile;
            };
            "anki/kg" = {
              key = "anki/password";
              inherit sopsFile;
            };
          };

        users.users.kg = {
          isNormalUser = true;
          hashedPasswordFile = config.sops.secrets.kg_password.path;
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGlAyglgR4yyhiIy0K4hzu0syefzRE/IsKkx+IskC7xF kg@aladdin"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINKtrZt+5zMkOVy2RByh713FvkRpYuxdAB0k7th9yxVP kg@sindbad"
          ];
          extraGroups = [
            "networkmanager"
            "wheel"
            "input"
            "audio"
            "video"
            "tss" # TPM
          ];
        };
      };

    homeManager.users-kg = moduleWithSystem (
      { inputs', ... }:
      { config, pkgs, ... }:
      let
        invisible = import (inputs.nix-invisible + /users/${config.home.username}.nix);
      in
      {
        imports = [
          inputs.sops-nix.homeModules.default
        ]
        ++ (with toplevel.config.flake.modules.homeManager; [
          catppuccin
          nix
          shells
          ssh
          vcs
        ]);

        vcs.user = {
          name = "KP64";
          inherit (invisible) email;
        };

        home = {
          stateVersion = "25.11";
          shellAliases.c = "clear";
          packages = [
            inputs'.dotz.packages.default
          ]
          ++ (with pkgs; [
            bluetui
            pavucontrol
            prismlauncher
            yubikey-manager
            yubioath-flutter
          ]);
        };

        sops = {
          defaultSopsFile = ./secrets.yaml;
          age = {
            keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
            generateKey = true;
          };
        };

        programs.obs-studio = {
          enable = true;
          plugins = with pkgs.obs-studio-plugins; [
            droidcam-obs
            wlrobs
          ];
        };

        services = {
          pueue.enable = true;
          yubikey-agent.enable = true;
        };

        programs = {
          bat.enable = true;
          btop.enable = true;
          cava.enable = true;
          fzf.enable = true;
          ripgrep.enable = true;
          zellij.enable = true;
        };
      }
    );
  };
}
