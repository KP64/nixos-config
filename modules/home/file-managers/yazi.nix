{

  config,
  lib,
  pkgs,
  ...
}:
{
  options.file-managers.yazi.enable = lib.mkEnableOption "Yazi";

  config = lib.mkIf config.file-managers.yazi.enable {
    home.packages = [ pkgs.exiftool ];
    programs.yazi = {
      enable = true;
      settings.manager.show_hidden = true;
    };
  };
}
