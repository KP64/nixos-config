{ self, ... }:
{
  flake.modules.homeManager.users-kg-hyprlock =
    { config, ... }:
    {
      home.file.".face".source = builtins.path {
        path = self + /modules/users/${config.home.username}/pfp.jpg;
      };
      xdg.configFile."background".source = builtins.path {
        path = self + /assets/wallpapers/catppuccin/cat-vibin.png;
      };

      # Prepopulated via Catppuccin
      programs.hyprlock.enable = true;
    };
}
