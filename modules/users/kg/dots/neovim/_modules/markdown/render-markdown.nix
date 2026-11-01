{
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
}
