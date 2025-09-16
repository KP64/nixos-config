{ inputs, ... }:
let
  wallpaper = "${inputs.self}/assets/wallpapers/catppuccin/retro2_live.png";
in
{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ wallpaper ];
      wallpaper = [ ", ${wallpaper}" ];
    };
  };
}
