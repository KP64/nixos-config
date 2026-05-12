{
  flake.modules.nixvim.which-key = {
    plugins.which-key = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
      settings.preset = "helix";
    };
  };
}
