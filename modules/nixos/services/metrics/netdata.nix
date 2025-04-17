{ config, lib, ... }:
let
  cfg = config.services.metrics.netdata;
in
{
  options.services.metrics.netdata.enable = lib.mkEnableOption "Netdata";

  config = lib.mkIf cfg.enable {
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
  };
}
