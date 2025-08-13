{
  opts = {
    cursorline = true;
    number = true;
    termguicolors = true;
  };

  plugins.modicator = {
    enable = true;
    lazyLoad.settings.event = [
      "BufNewFile"
      "BufReadPre"
    ];
  };
}
