{ config, lib, ... }:
let
  cfg = config.services.metrics.loki;
  inherit (config.services) loki;
in
{
  options.services.metrics.loki.enable = lib.mkEnableOption "Loki";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      environment.etc."alloy/config.alloy".source = ./config.alloy;

      services = {
        grafana.provision.datasources.settings.datasources = [
          {
            name = "Loki";
            type = "loki";
            url = "http://127.0.0.1:${toString loki.configuration.server.http_listen_port}";
            jsonData = {
              timeout = 60;
              maxLines = 1000;
            };
          }
        ];

        # TODO:
        # alloy = {
        #   enable = true;
        #   # Do not send telemetry
        #   extraFlags = [ "--disable-reporting" ];
        # };

        loki = {
          enable = true;
          configuration = {
            auth_enabled = false;
            server.http_listen_port = 3100;

            limits_config = {
              allow_structured_metadata = true;
              volume_enabled = true;
            };

            pattern_ingester.enabled = true;

            common = {
              ring = {
                instance_addr = "127.0.0.1";
                kvstore.store = "inmemory";
              };
              replication_factor = 1;
              path_prefix = "/tmp/loki";
            };

            storage_config.filesystem.directory = "${loki.dataDir}/chunks";

            schema_config.configs = [
              {
                from = "2020-05-15";
                store = "tsdb";
                object_store = "filesystem";
                schema = "v13";
                index = {
                  prefix = "index_";
                  period = "24h";
                };
              }
            ];
          };
        };
      };
    })

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".directories = lib.optional cfg.enable loki.dataDir;
    })
  ];
}
