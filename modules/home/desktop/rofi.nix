{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop.rofi;
in
{
  options.desktop.rofi.enable = lib.mkEnableOption "Rofi";

  # TODO: Custom config
  config.programs.rofi = {
    inherit (cfg) enable;
    package = pkgs.rofi-wayland;
    plugins = [ pkgs.rofi-emoji-wayland ];
  };
}
