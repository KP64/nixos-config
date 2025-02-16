{
  lib,
  config,
  pkgs,
  username,
  ...
}:
{
  options.gaming.emulators.xbox.enable = lib.mkEnableOption "Xbox";

  config = lib.mkIf config.gaming.emulators.xbox.enable {
    home-manager.users.${username}.home.packages = [ pkgs.xemu ];
  };
}
