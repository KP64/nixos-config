{
  config,
  lib,
  rootPath,
  ...
}:
let
  cfg = config.desktop.hyprpaper;
in
{
  options.desktop.hyprpaper = {
    enable = lib.mkEnableOption "Hyprpaper";
    wallpaper = lib.mkOption {
      default = "${rootPath}/assets/wallpapers/catppuccin/nixos-waves.png";
      type = lib.types.path;
      description = "Path to the wallpaper.";
    };
  };

  config.services.hyprpaper = {
    inherit (cfg) enable;
    settings = {
      preload = [ (toString cfg.wallpaper) ];
      wallpaper = [ ", ${toString cfg.wallpaper}" ];
    };
  };
}
