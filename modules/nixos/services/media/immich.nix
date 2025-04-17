{ config, lib, ... }:
let
  cfg = config.services.media.immich;
in
{
  options.services.media.immich = {
    enable = lib.mkEnableOption "Immich";

    secretsFile = lib.mkOption {
      default = null;
      type = with lib.types; nullOr path;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      traefik.dynamicConfigOptions.http = {
        routers.immich = {
          rule = "Host(`immich.${config.networking.domain}`)";
          service = "immich";
        };
        services.immich.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.immich.port}"; }
        ];
      };

      immich = {
        enable = true;
        inherit (cfg) secretsFile;
      };
    };
  };
}
