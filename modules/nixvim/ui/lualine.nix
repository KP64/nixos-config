{
  flake.aspects.lualine.nixvim = {
    plugins.lualine = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
    };
  };
}
