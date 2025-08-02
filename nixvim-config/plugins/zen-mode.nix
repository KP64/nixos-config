{
  plugins = {
    zen-mode.enable = true;
    twilight.enable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>zn";
      action = "<CMD>ZenMode<CR>";
      options.desc = "Zen Mode";
    }
  ];
}
