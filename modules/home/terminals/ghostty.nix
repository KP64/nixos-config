{ config, lib, ... }:
let
  cfg = config.terminals.ghostty;
in
{
  options.terminals.ghostty = {
    enable = lib.mkEnableOption "Ghostty";
    shader = lib.mkOption {
      default = null;
      type = with lib.types; nullOr path;
      description = "Path to the glsl shader.";
    };
  };

  config.programs.ghostty = {
    inherit (cfg) enable;
    installBatSyntax = true;
    installVimSyntax = true;
    settings = {
      auto-update = "off";
      font-family = "JetBrainsMono Nerd Font";
      background-blur = true;
      background-opacity = 0.5;
      clipboard-trim-trailing-spaces = true;
      clipboard-paste-protection = true;
    } // lib.optionalAttrs (cfg.shader != null) { custom-shader = toString cfg.shader; };
  };
}
