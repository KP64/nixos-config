{
  flake.aspects.which-key.nixvim = {
    plugins.which-key = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
      settings.preset = "helix";
    };
  };
}
