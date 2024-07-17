{
  pkgs,
  lib,
  config,
  inputs,
  username,
  ...
}:

let
  wallpapers = map (x: builtins.toString x) [
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
      package = inputs.hyprpaper.packages.${pkgs.system}.hyprpaper;
      settings = {
        preload = wallpapers;
        wallpaper = [ ", ${active_wallpaper}" ];
      };
    };
  };
}
