{
  lib,
  config,
  username,
  ...
}:
{
  options.desktop.services.blueman-app.enable = lib.mkEnableOption "Blueman Applet";

  config = lib.mkIf config.desktop.services.blueman-app.enable {
    services.blueman.enable = true;
    home-manager.users.${username}.services.blueman-applet.enable = true;
  };
}
