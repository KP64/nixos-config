{
  flake.aspects.dashboard.nixvim =
    { config, lib, ... }:
    {
      options.neovim-dashboard = lib.mkOption {
        readOnly = true;
        type = with lib.types; listOf str;
        description = "The Header of your neovim dashboard";
      };

      config.plugins.dashboard = {
        enable = true;
        settings = {
          config = {
            disable_move = true;
            header = config.neovim-dashboard;
            packages.enable = false;
            footer = lib.nixvim.utils.emptyTable;
            shortcut = [
              {
                action = "Telescope find_files cwd=";
                desc = "Files";
                group = "Label";
                key = "f";
              }
            ];
          };
        };
      };
    };
}
