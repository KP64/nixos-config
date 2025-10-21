{
  flake.modules.nixvim.treesitter = {
    dependencies = {
      tree-sitter.enable = true;
      git.enable = true;
      gcc.enable = true;
    };

    # Prevents everything to be folded on start
    opts.foldlevelstart = 99;

    plugins = {
      treesitter = {
        enable = true;
        folding = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };
      treesitter-context = {
        enable = true;
        settings.max_lines = 7;
      };
      treesitter-refactor = {
        enable = true;
        settings.smart_rename = {
          enable = true;
          keymaps.smart_rename = "gR";
        };
      };
      # TODO: Mappings
      treesitter-textobjects = {
        enable = true;
        lspInterop = {
          enable = true;
          border = "rounded";
        };
        move.enable = true;
        select = {
          enable = true;
          lookahead = true;
        };
        swap.enable = true;
      };
    };
  };
}
