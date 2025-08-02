{
  dependencies = {
    tree-sitter.enable = true;
    git.enable = true;
    gcc.enable = true;
  };

  plugins = {
    treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        incremental_selection.enable = true;
      };
    };
    treesitter-context.enable = true;
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
