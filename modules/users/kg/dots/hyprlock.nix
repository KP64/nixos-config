{ inputs, ... }:
{
  flake.modules.homeManager.users-kg-hyprlock = {
    home.file.".face".source = builtins.path { path = ../pfp.jpg; };
    xdg.configFile."background".source = builtins.path {
      path = inputs.self + /assets/wallpapers/catppuccin/cat-vibin.png;
    };

    # Prepopulated via Catppuccin
    programs.hyprlock.enable = true;
  };
}
