{
  lib,
  config,
  username,
  ...
}:
{
  options.desktop.services.udiskie.enable = lib.mkEnableOption "Udiskie";

  config = lib.mkIf config.desktop.services.udiskie.enable {
    services.udisks2.enable = true;
    home-manager.users.${username}.services.udiskie.enable = true;
  };
}
