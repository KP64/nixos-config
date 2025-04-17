{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options.editors.imhex.enable = lib.mkEnableOption "ImHex";

  config.home = lib.mkIf config.editors.imhex.enable {
    file.".local/share/imhex/themes" = {
      source = "${inputs.catppuccin-imhex}/themes/";
      recursive = true;
    };
    packages = [ pkgs.imhex ];
  };
}
