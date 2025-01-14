{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.file-managers.thunar;
in
{
  options.file-managers.thunar.enable = lib.mkEnableOption "Thunar";

  config.programs.thunar = {
    inherit (cfg) enable;
    plugins = with pkgs.xfce; [
      thunar-volman
      thunar-archive-plugin
      thunar-media-tags-plugin
    ];
  };
}
