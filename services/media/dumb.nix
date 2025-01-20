{ config, lib, ... }:
let
  cfg = config.services.media.dumb;
  dumbPort = 5555;
  port = toString dumbPort;
in
{
  options.services.media.dumb.enable = lib.mkEnableOption "Dumb";

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.dumb = {
      image = "ghcr.io/rramiachraf/dumb:latest";
      ports = [ "${port}:${port}" ];
    };

    services = {
      traefik.dynamicConfigOptions.http = {
        routers.dumb = {
          rule = "Host(`dumb.${config.networking.domain}`)";
          service = "dumb";
        };
        services.dumb.loadBalancer.servers = [ { url = "http://localhost:${port}"; } ];
      };

      tor.relay.onionServices.dumb.map = [
        {
          port = 80;
          target = {
            addr = "127.0.0.1";
            port = dumbPort;
          };
        }
      ];
    };
  };
}
