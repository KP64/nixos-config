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
  options.system.fonts = {
    enable = lib.mkEnableOption "Whether or not to manage fonts.";
    extraFonts = lib.mkOption {
      default = [ ];
      description = "Custom font packages to install.";
      type = with lib.types; listOf package;
    };
  };

  config = lib.mkIf cfg.enable {
    fonts.packages =
      with pkgs;
      [
        dejavu_fonts
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
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
  };
}
