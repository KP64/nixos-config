{ pkgs, inputs, ... }:

let
  absolute_wallpapers = map (x: builtins.toString x) [
    ../../wallpapers/nix-wallpaper-nineish-dark-gray.png
    ../../wallpapers/nixos-wallpaper-catppuccin-mocha.png
  ];

  active_wallpaper = builtins.elemAt absolute_wallpapers 1;
in
{
  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages.${pkgs.system}.hyprpaper;
    settings = {
      preload = absolute_wallpapers;

      wallpaper = [ ", ${active_wallpaper}" ];
    };
  };
}
