{
  pkgs,
  lib,
  config,
  username,
  ...
}:
{
  options.file-managers.yazi.enable = lib.mkEnableOption "Yazi";

  config = lib.mkIf config.file-managers.yazi.enable {
    home-manager.users.${username} = {
      home.packages = [ pkgs.exiftool ];
      programs.yazi = {
        enable = true;
        settings.manager.show_hidden = true;
      };
    };
  };
}
