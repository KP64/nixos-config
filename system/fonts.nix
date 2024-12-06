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
      nerd-fonts.symbols-only
    ];
  };

  config.fonts.packages =
    (with pkgs.nerd-fonts; [
      fira-code
      fira-mono
      jetbrains-mono
      noto
      symbols-only
    ])
    ++ (with pkgs; [
      dejavu_fonts
      font-awesome
    ])
    ++ cfg.extraFonts;

}
