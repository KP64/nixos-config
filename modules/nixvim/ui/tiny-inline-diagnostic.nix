{
  flake.aspects.tiny-inline-diagnostic.nixvim = {
    plugins.tiny-inline-diagnostic = {
      enable = true;
      lazyLoad.settings.event = "LspAttach";
    };
  };
}
