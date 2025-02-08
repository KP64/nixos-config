{ config, lib, ... }:
let
  cfg = config.services.metrics;
in
{
  imports = [
    ./grafana
    ./loki

    ./netdata.nix
    ./prometheus.nix
  ];

  options.services.metrics.enable = lib.mkEnableOption "Metrics";

  config.services.metrics = lib.mkIf cfg.enable {
    grafana.enable = lib.mkDefault true;
    loki.enable = lib.mkDefault true;
    prometheus.enable = lib.mkDefault true;
    # tempo.enable = lib.mkDefault true;
  };
}
