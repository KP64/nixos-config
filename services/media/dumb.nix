{ config, lib, ... }:
let
  cfg = config.services.media.dumb;
  dumbPort = "5555";
in
{
  options.services.media.dumb.enable = lib.mkEnableOption "Dumb";

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.dumb = {
      image = "ghcr.io/rramiachraf/dumb:latest";
      ports = [ "${dumbPort}:${dumbPort}" ];
    };

    services.traefik.dynamicConfigOptions.http = {
      routers.dumb = {
        rule = "Host(`dumb.${config.networking.domain}`)";
        service = "dumb";
      };
      services.dumb.loadBalancer.servers = [ { url = "http://localhost:${dumbPort}"; } ];
    };
  };
}
