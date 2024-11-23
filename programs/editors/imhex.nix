{
  lib,
  config,
  pkgs,
  inputs,
  username,
  ...
}:

{
  options.editors.imhex.enable = lib.mkEnableOption "ImHex";

  config = lib.mkIf config.editors.imhex.enable {
    home-manager.users.${username}.home = {
      file.".local/share/imhex/themes" = {
        source = "${inputs.catppuccin-imhex}/themes/";
        recursive = true;
      };
      packages = [ pkgs.imhex ];
    };
  };
}
