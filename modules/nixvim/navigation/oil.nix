{
  flake.modules.nixvim.oil = { config, lib, ... }: {
    performance.combinePlugins.standalonePlugins = lib.optional config.plugins.blink-cmp.enable "oil.nvim";

    plugins = {
      oil-git-status.enable = true;
      oil = {
        enable = true;
        settings = {
          experimental_watch_for_changes = true;
          # Needed for oil-git-status
          win_options.signcolumn = "${lib.boolToYesNo true}:2";
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
