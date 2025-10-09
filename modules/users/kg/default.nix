toplevel@{ moduleWithSystem, inputs, ... }:
{
  flake.modules = {
    nixos.users-kg =
      { config, ... }:
      {
        imports = [ inputs.nur.modules.nixos.default ];

        home-manager.users.kg.imports = [ toplevel.config.flake.modules.homeManager.users-kg ];

        sops.secrets.kg_password = {
          neededForUsers = true;
          key = "password";
          sopsFile = ./secrets.yaml;
        };

        users.users.kg = {
          isNormalUser = true;
          hashedPasswordFile = config.sops.secrets.kg_password.path;
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

    homeManager.users-kg = moduleWithSystem (
      { inputs', ... }:
      { config, pkgs, ... }:
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

        sops = {
          defaultSopsFile = ./secrets.yaml;
          age = {
            keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
            generateKey = true;
          };
          # TODO: Paste private SSH key?
          # secrets."private_keys/kg".path = "${config.home.homeDirectory}/.ssh/id_ed25519";
        };

        programs.obs-studio = {
          enable = true;
          plugins = with pkgs.obs-studio-plugins; [
            droidcam-obs
            wlrobs
          ];
        };

        programs.nixvim = {
          enable = true;
          defaultEditor = true;
          vimdiffAlias = true;
          imports =
            (with toplevel.config.flake.modules.nixvim; [
              base
              lsp
              ui

              codesnap
              comments
              git
              markdown
              movement
              telescope
              treesitter
              trouble
              which-key
              yazi
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
          packages = [
            inputs'.dotz.packages.default
          ]
          ++ (with pkgs; [
            bluetui
            pavucontrol
            prismlauncher
          ]);
        };

        services.pueue.enable = true;

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
