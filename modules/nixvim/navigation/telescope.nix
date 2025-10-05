{
  flake.modules.nixvim.telescope =
    { pkgs, ... }:
    {
      extraPackages = [ pkgs.fd ];
      dependencies.ripgrep.enable = true;

      plugins.telescope = {
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
}
