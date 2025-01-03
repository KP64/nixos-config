{
  lib,
  config,
  pkgs,
  username,
  ...
}:
{
  options.browsers.tor.enable = lib.mkEnableOption "Tor";

  config = lib.mkIf config.browsers.tor.enable {
    home-manager.users.${username}.home.packages = [ pkgs.tor-browser ];
  };
}
