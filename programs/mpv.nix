{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.apps.mpv;
in
{
  options.apps.mpv.enable = lib.mkEnableOption "mpv";

  config.home-manager.users.${username}.programs.mpv = { inherit (cfg) enable; };
}
