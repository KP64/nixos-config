{ inputs, ... }:
{
  flake.modules.homeManager.users-kg =
    { config, ... }:
    {
      # FIXME: HUH??? Since when is "../profile.jpg" not an absolute path?
      # Why does this resolve to "/nix/store/profile.jpg"????
      #
      # home.file.".face".source = ../profile.jpg;

      # Workaround
      home.file.".face".source = "${inputs.self}/modules/users/${config.home.username}/pfp.jpg";
      xdg.configFile."background".source = "${inputs.self}/assets/wallpapers/catppuccin/cat-vibin.png";

      # Prepopulated via Catppuccin
      programs.hyprlock.enable = true;
    };
}
