{
  pkgs,
  lib,
  config,
  username,
  ...
}:

{
  imports = [
    ./discord.nix
    ./gamemode.nix
    ./heroic.nix
    ./mangohud.nix
    ./steam.nix
  ];

  options.gaming.enable = lib.mkEnableOption "Enables Some gaming Apps";

  config = lib.mkIf config.gaming.enable {
    home-manager.users.${username}.home.packages = with pkgs; [
      dolphin-emu
      cemu
      ryujinx

      wineWowPackages.waylandFull
      xemu

      atlauncher
      steam-run
      openarena
    ];
  };
}
