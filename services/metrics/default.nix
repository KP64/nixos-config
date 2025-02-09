{ config, lib, ... }:
let
  cfg = config.services.metrics;
in
{
  imports = [ ./netdata.nix ];

  options.services.metrics.enable = lib.mkEnableOption "Metrics";

  config.services.metrics = lib.mkIf cfg.enable { netdata.enable = lib.mkDefault true; };
}
