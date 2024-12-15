{
  pkgs,
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.desktop.rofi;
in
{
  options.desktop.rofi.enable = lib.mkEnableOption "Rofi";

  config.home-manager.users.${username}.programs.rofi = {
    inherit (cfg) enable;
    package = pkgs.rofi-wayland;
    plugins = [ pkgs.rofi-emoji-wayland ];
  };
}
