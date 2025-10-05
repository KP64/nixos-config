{
  flake.modules.nixvim.render-markdown =
    { pkgs, ... }:
    {
      # Needed for latex support
      extraPackages = [ pkgs.python313Packages.pylatexenc ];

      plugins.render-markdown = {
        enable = true;
        lazyLoad.settings.ft = "markdown";
      };
    };
}
