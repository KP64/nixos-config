{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.desktop.services.mako;
in
{
  options.desktop.services.mako.enable = lib.mkEnableOption "Mako";

  config.home-manager.users.${username}.services.mako = {
    inherit (cfg) enable;
    defaultTimeout = 5000;
  };
}
