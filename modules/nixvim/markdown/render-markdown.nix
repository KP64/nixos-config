{
  flake.modules.nixvim.render-markdown =
    { pkgs, ... }:
    {
      dependencies.tree-sitter.enable = true;

      # Needed for latex support
      extraPackagesAfter = [ pkgs.python313Packages.pylatexenc ];

      plugins = {
        treesitter = {
          enable = true;
          settings.highlight.enable = true;
        };
        mini-icons.enable = true;

        render-markdown = {
          enable = true;
          lazyLoad.settings.ft = "markdown";
        };
      };
    };
}
