{
  flake.modules.nixvim.render-markdown = {
    plugins.render-markdown = {
      enable = true;
      lazyLoad.settings.ft = "markdown";
      # TODO: Check latex support
      settings.latex.enabled = false;
    };
  };
}
