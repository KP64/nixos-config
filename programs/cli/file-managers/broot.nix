{
  lib,
  config,
  username,
  ...
}:
{
  options.cli.file-managers.broot.enable = lib.mkEnableOption "Broot";

  config = lib.mkIf config.cli.file-managers.broot.enable {
    home-manager.users.${username}.programs.broot.enable = true;
  };
}
