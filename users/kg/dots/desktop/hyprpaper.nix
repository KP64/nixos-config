{ inputs, ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "${inputs.self}/assets/wallpapers/catppuccin/retro2_live.png" ];
      wallpaper = [ ", ${inputs.self}/assets/wallpapers/catppuccin/retro2_live.png" ];
    };
  };
}
