{
  flake.modules.nixvim.telescope = {
    dependencies = {
      fd.enable = true;
      ripgrep.enable = true;
      tree-sitter.enable = true;
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
