{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.cli.file-managers.broot;
in
{
  options.cli.file-managers.broot.enable = lib.mkEnableOption "Broot";

  config.home-manager.users.${username}.programs.broot = { inherit (cfg) enable; };
}
