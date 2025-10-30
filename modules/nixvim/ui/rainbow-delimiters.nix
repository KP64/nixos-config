{
  flake.modules.nixvim.rainbow-delimiters = {
    plugins.rainbow-delimiters = {
      enable = true;
      lazyLoad.settings.event = [
        "BufNew"
        "BufReadPre"
      ];
    };
  };
}
