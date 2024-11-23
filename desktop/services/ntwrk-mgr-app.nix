{
  lib,
  config,
  username,
  ...
}:
{
  options.desktop.services.ntwrk-mgr-app.enable = lib.mkEnableOption "Network Manager Applet";

  config = lib.mkIf config.desktop.services.ntwrk-mgr-app.enable {
    home-manager.users.${username}.services.network-manager-applet.enable = true;
  };
}
