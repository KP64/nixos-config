{ inputs, pkgs, ... }:

{
  home.packages = with pkgs; [
    gimp
    libreoffice-qt6-fresh
    hunspell
    hunspellDicts.en_US
    whatsapp-for-linux
    aseprite
    figma-linux
    pavucontrol
  ];
}
