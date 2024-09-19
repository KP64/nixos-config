{
  lib,
  config,
  pkgs,
  username,
  ...
}:
{
  options.gaming.emulators.xemu.enable = lib.mkEnableOption "Enables xemu";

  config = lib.mkIf config.gaming.emulators.xemu.enable {
    home-manager.users.${username}.home.packages = [ pkgs.xemu ];
  };
}
