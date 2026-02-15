toplevel@{ moduleWithSystem, inputs, ... }:
{
  # TODO: Check if aspect automatically adds this user including homeManager (no need for sharedModules?)
  flake.aspects.users-kg = {
    nixos =
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
          description = with config.home-manager.users.kg.invisible; "${firstName} ${lastName}";
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGlAyglgR4yyhiIy0K4hzu0syefzRE/IsKkx+IskC7xF kg@aladdin"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINKtrZt+5zMkOVy2RByh713FvkRpYuxdAB0k7th9yxVP kg@sindbad"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFeOXz+XfNnS01wYjjqNj5t9P20ZLzu8w5vU/0R7bu9R kg@mahdi"
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

    homeManager = moduleWithSystem (
      { inputs', ... }:
      { config, pkgs, ... }:
      {
        imports =
          (with inputs; [
            sops-nix.homeModules.default
            nix-invisible.modules.homeManager.user-kg
          ])
          ++ (with toplevel.config.flake.modules.homeManager; [
            catppuccin
            nix
            ssh
            vcs
            yubikey
          ])
          ++ (with toplevel.config.flake.modules.homeManager; [
            users-kg-yazi
            users-kg-atuin
            users-kg-delta
            users-kg-fd
            users-kg-neovim
            users-kg-shells
            users-kg-starship
            users-kg-zoxide
          ]);

        vcs.user = {
          name = "KP64";
          inherit (config.invisible) email;
        };

        home = {
          shellAliases.c = "clear";
          packages =
            let
              inherit (config.lib.packages) activatePerHosts;
            in
            (with pkgs; [
              bluetui
              caligula
            ])
            ++ activatePerHosts [
              {
                packages = [
                  inputs'.dotz.packages.default
                ]
                ++ (with pkgs; [
                  manga-tui
                  yubioath-flutter
                ]);
                hosts = [
                  "aladdin"
                  "sindbad"
                ];
              }
            ];
        };

        sops = {
          defaultSopsFile = ./secrets.yaml;
          age = {
            keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
            generateKey = true;
          };
        };

        services.pueue.enable = true;

        programs = {
          bat.enable = true;
          btop.enable = true;
          cava.enable = true;
          fastfetch.enable = true;
          ripgrep.enable = true;
          zellij.enable = true;
        };
      }
    );
  };
}
