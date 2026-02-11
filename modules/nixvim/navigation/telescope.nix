{
  flake.modules.nixvim.telescope = {
    dependencies =
      let
        defaultEnable = {
          enable = true;
          packageFallback = true;
        };
      in
      {
        fd = defaultEnable;
        ripgrep = defaultEnable;
        tree-sitter = defaultEnable;
      };

    plugins = {
      treesitter.enable = true;

      telescope = {
        enable = true;
        extensions.fzf-native.enable = true;

        settings.defaults = {
          layout_config.prompt_position = "top";
          sorting_strategy = "ascending";
        };

        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
        };
      };
    };
  };
}
