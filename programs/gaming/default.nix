{
  pkgs,
  lib,
  config,
  inputs,
  username,
  ...
}:

let
  stable-pkgs = inputs.stable-nixpkgs.legacyPackages.${pkgs.system};
in
{
  imports = [
    ./gamemode.nix
    ./heroic.nix
    ./mangohud.nix
    ./steam.nix
  ];

  options.gaming.enable = lib.mkEnableOption "Enables Some gaming Apps";

  config = lib.mkIf config.gaming.enable {
    home-manager.users.${username}.home.packages =
      with pkgs;
      [
        discord

        ryujinx
        cemu

        wineWowPackages.waylandFull
        xemu

        atlauncher
        steam-run
        openarena
      ]
      ++ [ stable-pkgs.dolphin-emu ];
  };
}
