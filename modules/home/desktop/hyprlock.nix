{
  config,
  lib,
  rootPath,
  ...
}:

let
  cfg = config.desktop.hyprlock;
in
{
  options.desktop.hyprlock.enable = lib.mkEnableOption "Hyprlock";

  config.programs.hyprlock = {
    inherit (cfg) enable;
    settings = {
      background = [
        {
          monitor = "";
          path = "${rootPath}/assets/wallpapers/astronaut.png";
          blur_passes = 0;
        }
      ];

      image = [
        {
          monitor = "";
          path = "";
          size = 100;
          border_color = "$lavender";
          position = "0, 75";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
