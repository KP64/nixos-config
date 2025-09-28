toplevel@{ inputs, ... }:
{
  flake.modules = {
    nixos.users-kg =
      { config, ... }:
      {
        imports = [ inputs.nur.modules.nixos.default ];

        home-manager.users.kg.imports = [ toplevel.config.flake.modules.homeManager.users-kg ];

        # TODO: Move sops file containing password to user
        sops.secrets."users/kg/password".neededForUsers = true;
        users.users.kg = {
          isNormalUser = true;
          hashedPasswordFile = config.sops.secrets."users/kg/password".path;
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGlAyglgR4yyhiIy0K4hzu0syefzRE/IsKkx+IskC7xF kg@aladdin"
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

    homeManager.users-kg =
      { config, ... }:
      let
        invisible = import "${inputs.nix-invisible}/users/${config.home.username}.nix";
      in
      {
        imports =
          (with inputs; [
            sops-nix.homeModules.default
            nixvim.homeModules.nixvim
          ])
          ++ (with toplevel.config.flake.modules.homeManager; [
            catppuccin
            fetchers
            nix
            shells
            ssh
            vcs
          ]);

        programs.nixvim = {
          enable = true;
          defaultEditor = true;
          vimdiffAlias = true;
          imports =
            (with toplevel.config.flake.modules.nixvim; [
              base
              lsp
              navigation
              ui

              codesnap
              comments
              git
              markdown
              movement
              treesitter
              trouble
              which-key
              zen
            ])
            ++ [
              { colorschemes.catppuccin.enable = true; }
              {
                neovim-dashboard = [
                  "  ██  ██  ████████  ████████  ██  ██  ██  ██  "
                  "  ██  ██  ██              ██  ██  ██          "
                  "  ██  ██  ██████████████████  ██  ██  ██████  "
                  "  ██  ██                      ██  ██  ██  ██  "
                  "  ██  ██  ██████  ██  ██████████  ██  ██████  "
                  "  ██  ██  ██                      ██      ██  "
                  "  ██  ██████████  ██  ██████  ██  ██████████  "
                  "  ██  ██          ██      ██      ██          "
                  "  ██████████  ██████  ██████  ██  ██  ██████  "
                  "      ██  ██  ██              ██  ██  ██  ██  "
                  "  ██  ██████  ██████  ██████████  ██  ██████  "
                  "  ██              ██              ██      ██  "
                  "  ██████████████████  ██████████████  ██████  "
                  "                                              "
                ];
              }
            ];
        };

        vcs.user = {
          name = "KP64";
          inherit (invisible) email;
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
      };
  };
}
