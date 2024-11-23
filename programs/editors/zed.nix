{
  lib,
  config,
  username,
  ...
}:

{
  options.editors.zed.enable = lib.mkEnableOption "Zed";
  config = lib.mkIf config.editors.zed.enable {
    home-manager.users.${username}.programs.zed-editor = {
      enable = true;
      extensions = [
        "html"
        "catppuccin"
        "dockerfile"
        "toml"
        "git-firefly"
        "sql"
        "svelte"
        "emmet"
        "nix"
        "env"
        "just"
        "typst"
        "nu"
        "surrealql"
      ];
      userSettings = {
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
        lsp.rust-analyzer.initialization_options.check.command = "clippy";
      };
    };
  };
}
