{
  pkgs,
  lib,
  config,
  inputs,
  username,
  ...
}:

{
  options.desktop.enable = lib.mkEnableOption "Enables Desktop Utilities";

  config = lib.mkIf config.desktop.enable {
    home-manager.users.${username}.home.packages =
      with inputs;
      [
        hyprpicker.packages.${pkgs.system}.hyprpicker
        hyprland-contrib.packages.${pkgs.system}.grimblast
      ]
      ++ (with pkgs; [
        xdg-utils
        libnotify
      ]);
  };
}
