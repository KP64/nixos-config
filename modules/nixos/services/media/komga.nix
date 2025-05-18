{ config, lib, ... }:
let
  cfg = config.services.media.komga;
in
{
  options.services.media.komga.enable = lib.mkEnableOption "Komga";

  config.services = lib.mkIf cfg.enable {
    traefik.dynamicConfigOptions.http = {
      routers.komga = {
        rule = "Host(`komga.${config.networking.domain}`)";
        service = "komga";
      };
      services.komga.loadBalancer.servers = [
        { url = "http://localhost:${toString config.services.komga.settings.server.port}"; }
      ];
    };

    komga = {
      enable = true;
      settings.server.port = 25600;
    };
  };
}
