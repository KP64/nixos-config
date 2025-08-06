{
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
}
