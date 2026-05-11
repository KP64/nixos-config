{
  flake.modules.nixvim.tiny-inline-diagnostic = {
    plugins.tiny-inline-diagnostic = {
      enable = true;
      lazyLoad.settings.event = "LspAttach";
    };
  };
}
