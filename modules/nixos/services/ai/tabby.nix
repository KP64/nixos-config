{ config, lib, ... }:
let
  cfg = config.services.ai.tabby;
in
{
  options.services.ai.tabby.enable = lib.mkEnableOption "Tabby";

  config = lib.mkIf cfg.enable {
    services = {
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
  };
}
