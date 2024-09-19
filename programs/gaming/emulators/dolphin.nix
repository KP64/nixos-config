{
  lib,
  config,
  pkgs,
  username,
  ...
}:
{
  options.gaming.emulators.dolphin.enable = lib.mkEnableOption "Enables dolphin";

  config = lib.mkIf config.gaming.emulators.dolphin.enable {
    home-manager.users.${username}.home.packages = [ pkgs.dolphin-emu ];
  };
}
