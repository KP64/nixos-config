{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (inputs.hyprland.packages.${pkgs.system}) hyprland xdg-desktop-portal-hyprland;
  cfg = config.desktop.hyprland;
in
{
  options.desktop.hyprland.enable = lib.mkEnableOption "Hyprland";

  config.programs.hyprland = lib.mkIf cfg.enable {
    enable = true;
    package = hyprland;
    portalPackage = xdg-desktop-portal-hyprland;
  };
}
