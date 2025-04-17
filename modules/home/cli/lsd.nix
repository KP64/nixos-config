{ config, lib, ... }:
let
  cfg = config.cli.lsd;
in
{
  options.cli.lsd.enable = lib.mkEnableOption "lsd";

  config.programs.lsd = {
    inherit (cfg) enable;
    enableAliases = true;
    settings.sorting.dir-grouping = "first";
  };
}
