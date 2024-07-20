{
  pkgs,
  lib,
  config,
  inputs,
  username,
  ...
}:
{
  options.desktop.hypr.contrib.grimblast.enable = lib.mkEnableOption "Enables Grimblast";

  config = lib.mkIf config.desktop.hypr.contrib.grimblast.enable {
    home-manager.users.${username}.home.packages = [
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    ];
  };
}
