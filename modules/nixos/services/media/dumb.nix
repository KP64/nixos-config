{ config, lib, ... }:
let
  cfg = config.services.media.dumb;
  port = 5555;
  dumbPort = toString port;
in
{
  options.services.media.dumb.enable = lib.mkEnableOption "Dumb";

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.dumb = {
      image = "ghcr.io/rramiachraf/dumb:latest";
      ports = [ "${dumbPort}:${dumbPort}" ];
    };

    services = {
      traefik.dynamicConfigOptions.http = {
        routers.dumb = {
          rule = "Host(`dumb.${config.networking.domain}`)";
          service = "dumb";
        };
        services.dumb.loadBalancer.servers = [ { url = "http://localhost:${dumbPort}"; } ];
      };

      tor.relay.onionServices.dumb.map = [
        {
          port = 80;
          target = {
            addr = "127.0.0.1";
            inherit port;
          };
        }
      ];

      i2pd.inTunnels.dumb = {
        enable = true;
        destination = "127.0.0.1";
        inherit port;
      };
    };
  };
}
