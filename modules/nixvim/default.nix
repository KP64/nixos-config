toplevel@{ inputs, ... }:
{
  imports = [ inputs.nixvim.flakeModules.default ];

  nixvim = {
    packages.enable = true;
    checks.enable = true;
  };

  perSystem =
    { system, ... }:
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
            treesitter
            trouble
            which-key
            zen
          ])
          ++ [
            { colorschemes.catppuccin.enable = true; }
            {
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
            }
          ];
      };
    };
}
