{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.desktop.services.copyq.enable = lib.mkEnableOption "Copyq";

  config = lib.mkMerge [
    { home.packages = [ pkgs.wl-clipboard-rs ]; }
    (lib.mkIf config.desktop.services.copyq.enable { services.copyq.enable = true; })
  ];
}
