{ pkgs, ... }:
{
  fonts.packages =
    (with pkgs; [
      dejavu_fonts
      font-awesome
    ])
    ++ (with pkgs.nerd-fonts; [
      fira-code
      jetbrains-mono
      noto
      symbols-only
    ]);
}
