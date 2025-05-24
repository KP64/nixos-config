{ pkgs, ... }:
{
  fonts.packages =
    (with pkgs; [
      dejavu_fonts
      font-awesome
      rubik
      lexend
      kreative-square
    ])
    ++ (with pkgs.nerd-fonts; [
      fira-code
      jetbrains-mono
      noto
      symbols-only
    ]);
}
