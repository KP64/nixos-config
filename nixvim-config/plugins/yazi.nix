{
  plugins.yazi = {
    enable = true;
    lazyLoad.settings.event = "DeferredUIEnter";
    settings = {
      open_for_directories = true;
      use_ya_for_event_reading = true;
      use_yazi_client_id_flag = true;
    };
  };

  # https://github.com/mikavilpas/yazi.nvim/issues/802
  globals.loaded_netrwPlugin = 1;

  keymaps = [
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>-";
      action = "<cmd>Yazi<cr>";
      options.desc = "Yazi: Open at the current file";
    }
  ];
}
