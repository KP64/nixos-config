{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.system.fonts;
in
{
  options.system.fonts.extraFonts = lib.mkOption {
    default = [ ];
    description = "Custom font packages to install.";
    type = with lib.types; listOf package;
    example = with pkgs; [
      noto-fonts
      nerd-fonts.jetbrains-mono
    ];
  };

  config.fonts.packages =
    (with pkgs; [
      dejavu_fonts
      font-awesome
    ])
    ++ (with pkgs.nerd-fonts; [
      fira-code
      fira-mono
      jetbrains-mono
      noto
      symbols-only
    ])
    ++ cfg.extraFonts;

}
