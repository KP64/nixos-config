toplevel@{ inputs, ... }:
{
  # TODO: Migrate to aspects
  flake-file.inputs = {
    neovim-nightly-overlay = {
      type = "github";
      owner = "nix-community";
      repo = "neovim-nightly-overlay";
    };
    nixvim = {
      type = "github";
      owner = "nix-community";
      repo = "nixvim";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  imports = [ inputs.nixvim.flakeModules.default ];

  nixvim = {
    packages.enable = true;
    checks.enable = true;
  };

  perSystem =
    { system, lib, ... }:
    {
      nixvimConfigurations.default = inputs.nixvim.lib.evalNixvim {
        inherit system;
        modules =
          (with toplevel.config.flake.modules.nixvim; [
            base
            lsp
            navigation
            ui

            comments
            git
            leetcode
            markdown
            movement
            no-neck-pain
            tex
            treesitter
            trouble
            which-key
            zen
          ])
          ++ lib.singleton {
            colorschemes.catppuccin.enable = true;
            neovim-dashboard = [
              "                             ██  ██                                         "
              "                                                                            "
              "                ██           ██████                                         "
              "                ██           ██  ██            ██  ██████  ██  ██           "
              "                ██    ██     ██████            ██  ██  ██  ██  ██           "
              "        ██  ██  ██    ██         ██  ██████    ██  ██████  ██  ██           "
              "        ██  ██  ███████████████████  ██  ██    ██   ████   ██  ██           "
              "        ██  ██████                   ████████████████████████  ██           "
              "        ██            ██  █████      ██                                     "
              "        ██                   ██  ██████  ████████████████████████████  ██   "
              "        ██                   ██                                    ██  ██   "
              "        ██████████  ██████   ██  ██  ██████    ██  ██████  ██  ██  ██  ██   "
              "   ██   ██  ██  ██  ██  ██   ██  ██  ██  ██    ██  ██  ██          ██  ██   "
              "   ██   ██  ██████  ██████   ██  ██  ██████    ██  ██████  ██████  ██  ██   "
              "   ██   ██      ██   ████    ██  ██      ██    ██      ██  ██  ██  ██  ██   "
              "   ███████  ██  ███████████████  ██  ██████    ██   ██ ██  ██████████  ██   "
              "            ██                                 ██   ██ ██      ██           "
              "            █████████████████████████████████████   █████████████           "
              "                                                                            "
              "                                                                            "
            ];
          };
      };
    };
}
