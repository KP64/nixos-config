{
  dependencies = {
    tree-sitter.enable = true;
    git.enable = true;
    gcc.enable = true;
  };

  # TODO: LazyLoad
  plugins = {
    treesitter.enable = true;
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
