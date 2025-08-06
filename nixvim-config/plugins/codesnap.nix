rec {
  plugins.codesnap = {
    enable = true;
    lazyLoad.settings = {
      cmd = [
        "CodeSnap"
      ]
      ++ map (c: "CodeSnap${c}") [
        "ASCII"
        "Highlight"
        "Save"
        "SaveHighlight"
      ];
      keys = keymaps |> map (builtins.getAttr "key");
    };
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
