{
  lib,
  config,
  ...
}:
{
  options.cli.monitors.bandwhich.enable = lib.mkEnableOption "Bandwhich";

  config = lib.mkIf config.cli.monitors.bandwhich.enable {
    programs.bandwhich.enable = true;
  };
}
