{
  flake.aspects.rainbow-delimiters.nixvim = {
    plugins.rainbow-delimiters = {
      enable = true;
      lazyLoad.settings.event = [
        "BufNew"
        "BufReadPre"
      ];
    };
  };
}
