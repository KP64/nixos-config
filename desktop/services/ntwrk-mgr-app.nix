{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.desktop.services.ntwrk-mgr-app;
in
{
  options.desktop.services.ntwrk-mgr-app.enable = lib.mkEnableOption "Network Manager Applet";

  config.home-manager.users.${username}.services.network-manager-applet = { inherit (cfg) enable; };
}
