{
  lib,
  config,
  username,
  ...
}:

let
  wallpapers = map toString [
    ../wallpapers/cat_pacman.png
    ../wallpapers/doggocat.png
    ../wallpapers/gradient-synth-cat.png
    ../wallpapers/nix-black-4k.png
    ../wallpapers/nix-wp-dg.png
    ../wallpapers/nix-wp-cat-mocha.png
    ../wallpapers/windows-error.jpg
  ];
  active_wallpaper = builtins.elemAt wallpapers 6;
in
{
  options.desktop.hypr.hyprpaper.enable = lib.mkEnableOption "Enables Hyprpaper";

  config = lib.mkIf config.desktop.hypr.hyprpaper.enable {
    home-manager.users.${username}.services.hyprpaper = {
      enable = true;
      settings = {
        preload = wallpapers;
        wallpaper = [ ", ${active_wallpaper}" ];
      };
    };
  };
}
