{ inputs, pkgs, ... }:

{
  home.packages =
    with inputs;
    [
      hyprpicker.packages.${pkgs.system}.hyprpicker
      hyprland-contrib.packages.${pkgs.system}.grimblast
    ]
    ++ (with pkgs; [
      xdg-utils
      libnotify
    ]);
}
