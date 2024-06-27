{ inputs, pkgs, ... }:

{
  home.packages = with pkgs; [
    discord
    wineWowPackages.waylandFull
    protonup
    dolphin-emu
    ryujinx
    xemu
    atlauncher
    steam-run
  ];
}
