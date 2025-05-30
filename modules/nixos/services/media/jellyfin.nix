{ config, lib, ... }:
let
  cfg = config.services.media.jellyfin;
in
{
  options.services.media.jellyfin.enable = lib.mkEnableOption "Jellyfin";

  config.services = lib.mkIf cfg.enable {
    traefik.dynamicConfigOptions.http = {
      routers.jellyfin = {
        rule = "Host(`jellyfin.${config.networking.domain}`)";
        service = "jellyfin";
      };
      services.jellyfin.loadBalancer.servers = [ { url = "http://localhost:8096"; } ];
    };

    jellyfin = {
      enable = true;
      group = "multimedia";
    };
  };
}
