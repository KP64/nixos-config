{
  lib,
  config,
  pkgs,
  username,
  ...
}:
{
  options.gaming.emulators.ryujinx.enable = lib.mkEnableOption "Ryujinx";

  config = lib.mkIf config.gaming.emulators.ryujinx.enable {
    home-manager.users.${username}.home.packages = [ pkgs.ryujinx-greemdev ];
  };
}
