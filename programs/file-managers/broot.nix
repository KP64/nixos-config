{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.file-managers.broot;
in
{
  options.file-managers.broot.enable = lib.mkEnableOption "Broot";

  config.home-manager.users.${username}.programs.broot = { inherit (cfg) enable; };
}
