{
  lib,
  config,
  username,
  ...
}:
{
  options.desktop.services.mako.enable = lib.mkEnableOption "Enables Mako";

  config = lib.mkIf config.desktop.services.mako.enable {
    home-manager.users.${username}.services.mako = {
      enable = true;
      defaultTimeout = 5000;
    };
  };
}
