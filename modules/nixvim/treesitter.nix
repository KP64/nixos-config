{
  flake.modules.nixvim.treesitter = {
    dependencies =
      let
        defaultEnable = {
          enable = true;
          packageFallback = true;
        };
      in
      {
        gcc = defaultEnable;
        git = defaultEnable;
        nodejs = defaultEnable;
        tree-sitter = defaultEnable;
      };

    # Prevents everything to be folded on start
    opts.foldlevelstart = 99;

    plugins = {
      treesitter = {
        enable = true;
        folding.enable = true;
        highlight.enable = true;
        indent.enable = true;
      };
      treesitter-context = {
        enable = true;
        settings.max_lines = 7;
      };
      # TODO: Mappings
      treesitter-textobjects = {
        enable = true;
        settings = {
          lsp_interop = {
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
  };
}
