{
  flake.modules.nixvim.trouble = {
    plugins.trouble = {
      enable = true;
      lazyLoad.settings.cmd = "Trouble";
      settings = {
        auto_close = true;
        auto_refresh = true;
      };
    };

    # TODO: Broken on newest Neovim. Check when it is fixed
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
