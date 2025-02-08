{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.metrics.grafana;
  inherit (config.services) grafana;
in
{
  options.services.metrics.grafana.enable = lib.mkEnableOption "Grafana";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      environment.etc.grafana-dashboards = {
        source = ./dashboards;
        group = "grafana";
        user = "grafana";
      };

      services = {
        traefik.dynamicConfigOptions.http = {
          routers.grafana = {
            rule = "Host(`grafana.${config.networking.domain}`)";
            service = "grafana";
          };
          services.grafana.loadBalancer.servers = [
            { url = "http://localhost:${toString grafana.settings.server.http_port}"; }
          ];
        };

        # TODO: Tracing
        # tempo = {
        #   enable = true;
        #   extraFlags = [ "-config.expand-env=true" ];
        #   settings = { };
        # };

        grafana = {
          enable = true;
          declarativePlugins = with pkgs.grafanaPlugins; [
            grafana-github-datasource
            grafana-piechart-panel
          ];
          settings = {
            analytics = {
              reporting_enabled = false; # Do not send analytics
              feedback_links_enabled = false;
            };
            server = {
              domain = "grafana.${config.networking.domain}";
              http_port = 3698;
              enforce_domain = true;
              enable_gzip = true;
            };

            security = {
              cookie_secure = true;
              cookie_samesite = "strict";
              strict_transport_security_subdomains = true;
              strict_transport_security_preload = true;
              strict_transport_security = true;
              content_security_policy = true;
            };
          };

          # TODO: Set Admin Password via File provisioner
          # TODO: Hetzner when VPS is online
          provision = {
            enable = true;
            alerting = { };

            dashboards.settings.providers = [
              {
                name = "my dashboards";
                options.path = "/etc/grafana-dashboards";
              }
            ];

            datasources.settings.datasources = [
              {
                name = "GitHub (Personal Access Token)";
                type = "grafana-github-datasource";
                secureJsonData = { }; # TODO: Use File provider
              }
              # {
              #   name = "Loki";
              #   type = ""
              # }
              # {
              #   name =
              # }
            ];
          };
        };
      };
    })

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".directories = lib.optional cfg.enable grafana.dataDir;
    })
  ];
}
