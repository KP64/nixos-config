{
  lib,
  config,
  pkgs,
  username,
  ...
}:
{
  options.apps.browsers.tor.enable = lib.mkEnableOption "Tor";

  config = lib.mkIf config.apps.browsers.tor.enable {
    home-manager.users.${username}.home.packages = [ pkgs.tor-browser ];
  };
}
