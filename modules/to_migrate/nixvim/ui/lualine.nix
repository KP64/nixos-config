{
  flake.modules.nixvim.lualine = {
    plugins.lualine = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
    };
  };
}
