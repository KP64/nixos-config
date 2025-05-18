{ config, lib, ... }:
let
  cfg = config.services.misc.forgejo;
in
{
  options.services.misc.forgejo.enable = lib.mkEnableOption "Forgejo";

  config.services = lib.mkIf cfg.enable {
    traefik.dynamicConfigOptions.http = {
      routers.forgejo = {
        rule = "Host(`forgejo.${config.networking.domain}`)";
        service = "forgejo";
      };
      services.forgejo.loadBalancer.servers = [
        { url = "http://localhost:${toString config.services.forgejo.settings.server.HTTP_PORT}"; }
      ];
    };

    forgejo = {
      enable = true;
      settings.server.DOMAIN = "forgejo.${config.networking.domain}";
      dump = {
        enable = true;
        type = "tar";
      };
      lfs.enable = true;
    };
  };
}
