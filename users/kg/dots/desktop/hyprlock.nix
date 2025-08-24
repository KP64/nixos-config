{ inputs, ... }:
{
  programs.hyprlock.enable = true;

  xdg.configFile.background.source = "${inputs.self}/assets/wallpapers/catppuccin/cat-vibin.png";
  home.file.".face".source = "${inputs.self}/users/kg/face.jpg";
}
