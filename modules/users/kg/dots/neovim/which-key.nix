{
  den.aspects.kg.homeManager.programs.nixvim = {
    plugins.which-key = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
      settings.preset = "helix";
    };
  };
}
