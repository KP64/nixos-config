{
  pkgs,
  lib,
  config,
  stable-pkgs,
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
    home-manager.users.${username}.home.packages =
      [ stable-pkgs.dolphin-emu ]
      ++ (with pkgs; [
        ryujinx
        cemu

        wineWowPackages.waylandFull
        xemu

        atlauncher
        steam-run
        openarena
      ]);
  };
}
