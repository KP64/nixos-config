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
        # TODO: Organize modules better. Not entirely happy with separation.
        modules =
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
