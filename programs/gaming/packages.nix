{
  pkgs,
  lib,
  config,
  username,
  ...
}:
{
  options.gaming.enable = lib.mkEnableOption "Enables Some gaming Apps";

  config = lib.mkIf config.gaming.enable {
    home-manager.users.${username}.home.packages = with pkgs; [
      discord

      wineWowPackages.waylandFull
      dolphin-emu
      ryujinx
      xemu

      atlauncher
      steam-run
      openarena
    ];
  };
}
