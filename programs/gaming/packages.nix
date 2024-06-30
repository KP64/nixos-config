{
  pkgs,
  lib,
  config,
  username,
  ...
}:
{
  options.gaming.enable = lib.mkEnableOption "Enables The Heroic Game Launcher";

  config = lib.mkIf config.gaming.enable {
    home-manager.users.${username}.home.packages = with pkgs; [
      discord
      wineWowPackages.waylandFull
      protonup
      dolphin-emu
      ryujinx
      xemu
      atlauncher
      steam-run
      openarena
    ];
  };
}
