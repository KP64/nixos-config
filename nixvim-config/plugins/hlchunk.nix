{
  plugins.hlchunk = {
    enable = true;
    lazyLoad.settings.event = [
      "BufReadPre"
      "BufNewFile"
    ];
    settings.indent.enable = true;
  };
}
