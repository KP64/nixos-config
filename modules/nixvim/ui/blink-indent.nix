{
  flake.modules.nixvim.blink-indent = {
    plugins.blink-indent = {
      enable = true;
      settings.scope.enabled = false;
    };
  };
}
