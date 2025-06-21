{
  config,
  lib,
  pkgs,
  rootPath,
  ...
}:
let
  cfg = config.browsers.firefox;
in
{
  imports = [ ./profiles ];

  options.browsers.firefox.enable = lib.mkEnableOption "Firefox";

  config = lib.mkIf cfg.enable {
    xdg.desktopEntries.i2p-browser = {
      name = "i2p Browser";
      genericName = "Web Browser";
      icon = "${rootPath}/assets/firefox/i2p.svg";
      exec = "${lib.getExe pkgs.firefox} -p i2p";
    };

    programs.firefox.enable = true;
  };
}
