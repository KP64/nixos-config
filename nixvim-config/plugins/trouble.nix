{
  plugins.trouble = {
    enable = true;
    settings = {
      auto_close = true; # TODO: Annoying?
      auto_refresh = true;
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble diagnostics toggle<cr>";
      options.desc = "Diagnostics (Trouble)";
    }
  ];
}
