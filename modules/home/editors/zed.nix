{ config, lib, ... }:
let
  cfg = config.editors.zed;
in
{
  options.editors.zed.enable = lib.mkEnableOption "Zed";

  config.programs.zed-editor = {
    inherit (cfg) enable;
    extensions = [
      "html"
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
      format_on_save = "on";
      autosave.after_delay.milliseconds = 1000;
      auto_update = false;
      lsp.rust-analyzer.initialization_options.check.command = "clippy";
    };
  };
}
