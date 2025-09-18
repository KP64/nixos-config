{
  flake.modules.nixvim.navigation = {
    plugins.trouble = {
      enable = true;
      lazyLoad.settings.cmd = "Trouble";
      settings = {
        auto_close = true;
        auto_refresh = true;
      };
    };

    # TODO: Investigate 'provider "line"' treesitter issue
    keymaps = [
      {
        mode = "n";
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options.desc = "Diagnostics (Trouble)";
      }
    ];
  };
}
