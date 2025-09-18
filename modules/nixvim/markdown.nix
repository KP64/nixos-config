{
  flake.modules.nixvim.markdown = {
    plugins.render-markdown = {
      enable = true;
      lazyLoad.settings.ft = "markdown";
      settings.latex.enabled = false;
    };

    dependencies.imagemagick.enable = true;
    plugins.image = {
      enable = true;
      lazyLoad.settings.ft = [
        "markdown"
        "neorg"
        "typst"
        "html"
        "css"
      ];
    };
  };
}
