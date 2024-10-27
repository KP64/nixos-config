{
  pkgs,
  lib,
  config,
  username,
  ...
}:

{
  options.editors.zed.enable = lib.mkEnableOption "Enable Zed Editor";
  config = lib.mkIf config.editors.zed.enable {
    home-manager.users.${username} = {
      home.packages = [ pkgs.zed-editor ];
      xdg.configFile."zed/settings.json".text = builtins.toJSON {
        base_keymap = "VSCode";
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
        ui_font_size = 16;
        buffer_font_size = 16;
        theme = {
          mode = "system";
          light = "One Light";
          dark = "Catppuccin Mocha";
        };
        format_on_save = "on";
        autosave.after_delay.milliseconds = 1000;
        auto_update = false;
        auto_install_extensions = {
          html = true;
          catppuccin = true;
          dockerfile = true;
          toml = true;
          git-firefly = true;
          sql = true;
          svelte = true;
          emmet = true;
          nix = true;
          env = true;
          just = true;
          typst = true;
          nu = true;
          surrealql = true;
          harper = true;
        };
        lsp = {
          rust-analyzer.initialization_options.check.command = "clippy";
        };
      };
    };
  };

}
