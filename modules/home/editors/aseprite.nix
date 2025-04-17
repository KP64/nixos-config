{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.editors.aseprite;
in
{
  options.editors.aseprite.enable = lib.mkEnableOption "Aseprite";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.aseprite ];
    xdg.configFile."aseprite/extensions/catppuccin-theme-mocha" = {
      source = "${inputs.catppuccin-aseprite}/themes/mocha/catppuccin-theme-mocha";
      recursive = true;
    };
  };
}
