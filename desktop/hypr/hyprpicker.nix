{
  pkgs,
  lib,
  config,
  username,
  ...
}:
{
  options.desktop.hypr.hyprpicker.enable = lib.mkEnableOption "Enables Hyprpicker";

  config = lib.mkIf config.desktop.hypr.hyprpicker.enable {
    home-manager.users.${username}.home.packages = with pkgs; [ hyprpicker ];
  };
}
