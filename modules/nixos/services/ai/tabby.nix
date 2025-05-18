{ config, lib, ... }:
let
  cfg = config.services.ai.tabby;
in
{
  options.services.ai.tabby.enable = lib.mkEnableOption "Tabby";

  config.services = lib.mkIf cfg.enable {

    traefik.dynamicConfigOptions.http = {
      routers.tabby = {
        rule = "Host(`tabby.${config.networking.domain}`)";
        service = "tabby";
      };
      services.tabby.loadBalancer.servers = [
        { url = "http://localhost:${toString config.services.tabby.port}"; }
      ];
    };

    tabby.enable = true;
  };
}
