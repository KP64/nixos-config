{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gaming.emulators.xbox;
in
{
  options.gaming.emulators.xbox.enable = lib.mkEnableOption "Xbox";

  config.home.packages = lib.optional cfg.enable pkgs.xemu;
}
