{ config, ... }:
{
  # Prevents everything from being folded on start
  opts.foldlevelstart = 99;

  # Avoids conflicts with textobjects
  globals.no_plugin_maps = true;

  plugins = {
    treesitter = {
      enable = true;
      folding.enable = true;
      highlight.enable = true;
      indent.enable = true;
    };

    treesitter-context = {
      inherit (config.plugins.treesitter) enable;
      lazyLoad.settings.event = [
        "BufReadPost"
        "BufNewFile"
      ];
      settings.max_lines = 4;
    };

    # TODO: Add custom textobject keymaps
    #        -> look at: https://github.com/khaneliman/khanelivim/blob/main/modules/nixvim/plugins/treesitter-textobjects/default.nix
    treesitter-textobjects = {
      inherit (config.plugins.treesitter) enable;
      settings = {
        move.set_jumps = true;
        select = {
          lookahead = true;
          include_surrounding_whitespace = false;
          selection_modes = {
            "@parameter.outer" = "v";
            "@function.outer" = "V";
            "@class.outer" = "<C-v>";
          };
        };
      };
    };
  };
}
