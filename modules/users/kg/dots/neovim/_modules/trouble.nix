let
  cmd = "Trouble";
in
{
  plugins.trouble = {
    enable = true;
    lazyLoad.settings.cmd = [ cmd ];
    settings = {
      auto_close = true;
      auto_refresh = true;
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>xx";
      action = "<CMD>${cmd} diagnostics toggle<CR>";
      options.desc = "Diagnostics (Trouble)";
    }
  ];
}
