{ config, lib, ... }:
let
  cfg = config.services.metrics.prometheus;
  inherit (config.services) prometheus;
  inherit (prometheus) exporters;
in
{
  options.services.metrics.prometheus.enable = lib.mkEnableOption "Prometheus";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      services = {
        grafana.provision.datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            url = "http://127.0.0.1:${toString prometheus.port}";
          }
        ];

        prometheus = {
          enable = true;

          scrapeConfigs = [
            {
              job_name = "node";
              static_configs = [ { targets = [ "127.0.0.1:${toString exporters.node.port}" ]; } ];
            }
          ];

          exporters.node = {
            enable = true;
            enabledCollectors = [
              "ethtool"
              "softirqs"
              "tcpstat"
              "wifi"
              "systemd"
              "processes"
            ];
          };
        };
      };
    })

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".directories = lib.optional cfg.enable "/var/lib/prometheus2";
    })
  ];
}
