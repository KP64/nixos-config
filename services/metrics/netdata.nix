{ config, lib, ... }:
let
  cfg = config.services.metrics.netdata;
in
{
  options.services.metrics.netdata.enable = lib.mkEnableOption "Netdata";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      services = {
        traefik.dynamicConfigOptions.http = {
          routers.netdata = {
            rule = "Host(`netdata.${config.networking.domain}`)";
            service = "netdata";
          };
          services.netdata.loadBalancer.servers = [ { url = "http://localhost:19999"; } ];
        };

        netdata = {
          enable = true;
          python.recommendedPythonPackages = true;
          config.db.mode = "dbengine";
        };
      };
    })

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".directories = lib.optional cfg.enable "/var/lib/netdata";
    })
  ];
}
