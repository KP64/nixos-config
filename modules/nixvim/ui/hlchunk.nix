{
  flake.modules.nixvim.hlchunk = {
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
