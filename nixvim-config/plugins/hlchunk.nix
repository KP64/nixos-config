{
  plugins.hlchunk = {
    enable = true;
    lazyLoad.settings.event = [
      "BufNewFile"
      "BufReadPre"
    ];
    settings.indent.enable = true;
  };
}
