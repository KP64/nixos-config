{
  flake.modules.nixvim.dashboard =
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
            # TODO: Open issue that shortcuts can not be disabled.
            # This is because trying to set `shortcut` to an empty
            # table is not allowed per type signature of the nix option.
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
