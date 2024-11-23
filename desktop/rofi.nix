{
  pkgs,
  lib,
  config,
  username,
  ...
}:
{
  options.desktop.rofi.enable = lib.mkEnableOption "Rofi";

  config = lib.mkIf config.desktop.rofi.enable {
    home-manager.users.${username}.programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      plugins = [ pkgs.rofi-emoji-wayland ];
    };
  };
}
