{
  lib,
  config,
  pkgs,
  username,
  ...
}:
{
  options.gaming.emulators.xemu.enable = lib.mkEnableOption "Xemu";

  config = lib.mkIf config.gaming.emulators.xemu.enable {
    home-manager.users.${username}.home.packages = [ pkgs.xemu ];
  };
}
