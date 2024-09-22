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
  };

  config.fonts.packages =
    with pkgs;
    [
      dejavu_fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      font-awesome
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "JetBrainsMono"
          "Noto"
          "NerdFontsSymbolsOnly"
        ];
      })
    ]
    ++ cfg.extraFonts;

}
