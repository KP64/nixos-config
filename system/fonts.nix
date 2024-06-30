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
    # TODO: Make this work
    #fonts = lib.mkOption (lib.attrs) [ ] "Custom font packages to install.";
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
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
    ];
    # ++ cfg.fonts;
  };
}
