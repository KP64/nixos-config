{
  lib,
  config,
  username,
  ...
}:
{
  options.apps.mpv.enable = lib.mkEnableOption "Enables mpv";

  config = lib.mkIf config.apps.mpv.enable {
    home-manager.users.${username}.programs.mpv.enable = true;
  };
}
