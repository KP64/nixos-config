{
  flake.aspects.hlchunk.nixvim = {
    plugins.hlchunk = {
      enable = true;
      lazyLoad.settings.event = [
        "BufNewFile"
        "BufReadPost"
      ];
      settings.indent.enable = true;
    };
  };
}
