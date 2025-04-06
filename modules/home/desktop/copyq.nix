{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.desktop.services.copyq.enable = lib.mkEnableOption "Copyq";

  config = lib.mkIf config.desktop.services.copyq.enable {
    home.packages = [ pkgs.wl-clipboard-rs ];
    services.copyq.enable = true;
  };
}
