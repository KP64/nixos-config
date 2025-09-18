{
  flake.modules.nixvim.render-markdown = {
    plugins.render-markdown = {
      enable = true;
      lazyLoad.settings.ft = "markdown";
      settings.latex.enabled = false;
    };
  };
}
