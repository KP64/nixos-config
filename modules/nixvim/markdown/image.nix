{
  flake.aspects.image.nixvim = {
    dependencies.imagemagick = {
      enable = true;
      packageFallback = true;
    };

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
