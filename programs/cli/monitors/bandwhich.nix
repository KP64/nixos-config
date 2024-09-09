{
  lib,
  config,
  ...
}:
{
  options.cli.monitors.bandwhich.enable = lib.mkEnableOption "Enables bandwhich";

  config = lib.mkIf config.cli.monitors.bandwhich.enable {
    programs.bandwhich.enable = true;
  };
}
