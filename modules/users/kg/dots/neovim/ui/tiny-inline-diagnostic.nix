{
  den.aspects.kg.homeManager.programs.nixvim = {
    plugins.tiny-inline-diagnostic = {
      enable = true;
      lazyLoad.settings.event = "LspAttach";
    };
  };
}
