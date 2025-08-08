{
  dependencies = {
    tree-sitter.enable = true;
    git.enable = true;
    gcc.enable = true;
  };

  # Prevents everything to be folded on start
  opts.foldlevelstart = 99;

  # TODO: LazyLoad
  plugins = {
    treesitter = {
      enable = true;
      folding = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
    };
    treesitter-context.enable = true;
    treesitter-refactor = {
      enable = true;
      smartRename = {
        enable = true;
        keymaps.smartRename = "gR";
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
}
