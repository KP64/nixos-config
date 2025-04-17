{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.gaming.launchers.heroic;
in
{
  options.gaming.launchers.heroic.enable = lib.mkEnableOption "Heroic";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.heroic ];

    xdg.configFile."heroic/themes" = {
      source = "${inputs.catppuccin-heroic}/themes/";
      recursive = true;
    };
  };
}
