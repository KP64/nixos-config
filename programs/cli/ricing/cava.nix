{
  lib,
  config,
  username,
  ...
}:
{
  options.cli.ricing.cava.enable = lib.mkEnableOption "Enables cava";

  config = lib.mkIf config.cli.ricing.cava.enable {
    home-manager.users.${username}.programs.cava.enable = true;
  };
}
