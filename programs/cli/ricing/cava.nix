{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.cli.ricing.cava;
in
{
  options.cli.ricing.cava.enable = lib.mkEnableOption "Cava";

  config.home-manager.users.${username}.programs.cava = { inherit (cfg) enable; };
}
