{
  pkgs,
  lib,
  config,
  inputs,
  username,
  ...
}:

let
  absolute_wallpapers = map (x: builtins.toString x) [
    ../assets/wallpapers/nix-wp-dg.png
    ../assets/wallpapers/nix-wp-cat-mocha.png
  ];

  active_wallpaper = builtins.elemAt absolute_wallpapers 1;
in
{
  options.desktop.hypr.hyprpaper.enable = lib.mkEnableOption "Enables Hyprpaper";

  config = lib.mkIf config.desktop.hypr.hyprpaper.enable {
    home-manager.users.${username}.services.hyprpaper = {
      enable = true;
      package = inputs.hyprpaper.packages.${pkgs.system}.hyprpaper;
      settings = {
        preload = absolute_wallpapers;
        wallpaper = [ ", ${active_wallpaper}" ];
      };
    };
  };
}
