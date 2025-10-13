{ config, inputs, ... }:
{
  flake.modules.homeManager.users-kg = {
    imports = [ inputs.nixvim.homeModules.nixvim ];

    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      vimdiffAlias = true;
      imports =
        (with config.flake.modules.nixvim; [
          base
          lsp
          ui

          codesnap
          comments
          git
          leetcode
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
  };
}
