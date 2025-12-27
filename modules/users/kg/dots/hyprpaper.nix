{ self, ... }:
let
  # With this we ensure that the file exists.
  # If not the rebuild fails. Reproducibility baby! ;)
  # Can't count just how many times setting the
  # wallpaper failed because of typos.
  wallpaper = builtins.path { path = self + /assets/wallpapers/catppuccin/retro2_live.png; };
in
{
  flake.modules.homeManager.users-kg-hyprpaper = {
    services.hyprpaper = {
      enable = true;
      settings = {
        preload = [ wallpaper ];
        wallpaper = [ ", ${wallpaper}" ];
      };
    };
  };
}
