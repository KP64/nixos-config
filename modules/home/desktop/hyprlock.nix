{
  config,
  lib,
  pkgs,
  inputs,
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
    package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;
    settings = {
      background = [
        {
          monitor = "";
          path = "${rootPath}/assets/wallpapers/astronaut.png";
          blur_passes = 0;
          # color = "$base";
        }
      ];

      image = [
        {
          monitor = "";
          # path = if pfps == [ ] then "" else builtins.head pfps;
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
