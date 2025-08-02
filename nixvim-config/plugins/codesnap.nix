{
  # FIX: Crashes
  performance.combinePlugins.standalonePlugins = [ "codesnap.nvim" ];

  plugins.codesnap = {
    enable = true;
    settings = {
      bg_padding = 0;
      code_font_family = "JetBrainsMono Nerd Font";
      has_breadcrumbs = true;
      watermark = "";
    };
  };

  keymaps = [
    {
      key = "<leader>cc";
      action = "<cmd>CodeSnap<cr>";
      mode = "x";
      options.desc = "Save selected code snapshot into clipboard";
    }
    {
      key = "<leader>cs";
      action = "<cmd>CodeSnapSave<cr>";
      mode = "x";
      options.desc = "Save selected code snapshot in ~/Pictures";
    }
  ];
}
