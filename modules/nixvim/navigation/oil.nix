{
  flake.modules.nixvim.oil = {
    plugins = {
      oil-git-status.enable = true;
      oil = {
        enable = true;
        settings = {
          experimental_watch_for_changes = true;
          # Needed for oil-git-status
          win_options.signcolumn = "yes:2";
        };
      };
    };

    keymaps = [
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>-";
        action = "<CMD>Oil<CR>";
        options.desc = "Open parent directory";
      }
    ];
  };
}
