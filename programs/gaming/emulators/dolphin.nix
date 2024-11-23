{
  lib,
  config,
  stable-pkgs,
  username,
  ...
}:
{
  options.gaming.emulators.dolphin.enable = lib.mkEnableOption "Dolphin";

  config = lib.mkIf config.gaming.emulators.dolphin.enable {
    home-manager.users.${username}.home.packages = [ stable-pkgs.dolphin-emu ];
  };
}
