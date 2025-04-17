{ config, lib, ... }:
let
  cfg = config.services.media.jellyseerr;
in
{
  options.services.media.jellyseerr.enable = lib.mkEnableOption "Jellyseerr";

  config = lib.mkIf cfg.enable {
    services = {
      traefik.dynamicConfigOptions.http = {
        routers.jellyseerr = {
          rule = "Host(`jellyseerr.${config.networking.domain}`)";
          service = "jellyseerr";
        };
        services.jellyseerr.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.jellyseerr.port}"; }
        ];
      };

      jellyseerr.enable = true;
    };
  };
}
