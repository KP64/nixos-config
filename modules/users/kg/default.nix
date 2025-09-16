toplevel@{ inputs, ... }:
{
  flake.modules = {
    nixos.users-kg =
      { config, ... }:
      {
        imports = [ inputs.nur.modules.nixos.default ];

        home-manager.users.kg.imports = [ toplevel.config.flake.modules.homeManager.users-kg ];

        sops.secrets."users/kg/password".neededForUsers = true;
        users.users.kg = {
          isNormalUser = true;
          hashedPasswordFile = config.sops.secrets."users/kg/password".path;
          # TODO
          openssh.authorizedKeys.keys = [ ];
          extraGroups = [
            "networkmanager"
            "wheel"
            "input"
            "audio"
            "video"
            "tss" # TPM
            "docker"
            "podman"
            "vboxusers"
          ];
        };
      };

    homeManager.users-kg =
      { config, lib, ... }:
      let
        inherit (config.home) homeDirectory;
      in
      {
        imports = [
          inputs.sops-nix.homeModules.default
          ./_dots
        ]
        ++ (with toplevel.config.flake.modules.homeManager; [
          catppuccin
          fetchers
          nix
          shells
          ssh
          vcs
        ]);

        vcs.user = {
          name = "KP64";
          email = "karamalsadeh@hotmail.com";
        };

        sops = {
          defaultSopsFile = ./secrets.yaml;
          age = {
            keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
            sshKeyPaths = [ "${homeDirectory}/.ssh/id_ed25519" ];
          };
          secrets = { };
        };

        home = {
          stateVersion = "25.11";
          shellAliases.c = "clear";
        };

        programs = {
          bat.enable = true;
          btop.enable = true;
          cava.enable = true;
          fzf.enable = true;
          ripgrep.enable = true;
        };

        programs.atuin = {
          enable = true;
          daemon.enable = true;
          settings = {
            invert = true;
            filter_mode_shell_up_key_binding = "directory";
            style = "auto";
            update_check = false;
            enter_accept = true;
          };
        };

        programs.fd = {
          enable = true;
          hidden = true;
        };

        programs.starship = {
          enable = true;
          settings = lib.importTOML ./bracketed-segments.toml;
        };

        programs.zoxide = {
          enable = true;
          options = [ "--cmd cd" ];
        };

        programs.helix = {
          enable = true;
          defaultEditor = true;
          settings.editor = {
            true-color = true;
            file-picker.hidden = false;
            lsp.display-inlay-hints = true;
            cursor-shape = {
              insert = "bar";
              normal = "block";
              select = "underline";
            };
          };
        };

        programs.kitty = {
          enable = true;
          font.name = "JetBrainsMono Nerd Font";
          enableGitIntegration = true;
          settings = {
            shell = lib.mkIf config.programs.nushell.enable "nu";
            background_opacity = 0.9;
          };
        };
      };
  };
}
