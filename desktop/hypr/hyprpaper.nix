{
  lib,
  config,
  username,
  ...
}:

let
  cfg = config.desktop.hypr.hyprpaper;
in
{
  options.desktop.hypr.hyprpaper = {
    enable = lib.mkEnableOption "Hyprpaper";
    wallpaper = lib.mkOption {
      default = ../wallpapers/cat-nix.png;
      type = lib.types.path;
      example = ../wallpapers/night.png;
      description = "Path to the wallpaper.";
    };
  };

  config.home-manager.users.${username}.services.hyprpaper = {
    inherit (cfg) enable;
    settings = lib.mkIf (!config.isStylixEnabled) {
      preload = [ (toString cfg.wallpaper) ];
      wallpaper = [ ", ${toString cfg.wallpaper}" ];
    };
  };
}
