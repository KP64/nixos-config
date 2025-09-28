{ inputs, ... }:
{
  flake.modules.homeManager.users-kg =
    { config, ... }:
    {
      home.file.".face".source = ../pfp.jpg;
      xdg.configFile."background".source = "${inputs.self}/assets/wallpapers/catppuccin/cat-vibin.png";

      # Prepopulated via Catppuccin
      programs.hyprlock.enable = true;
    };
}
