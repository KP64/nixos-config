{
  lib,
  config,
  ...
}:
let
  cfg = config.cli.monitors.bandwhich;
in
{
  options.cli.monitors.bandwhich.enable = lib.mkEnableOption "Bandwhich";

  config.programs.bandwhich = { inherit (cfg) enable; };
}
