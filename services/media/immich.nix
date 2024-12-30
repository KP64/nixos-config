{
  config,
  lib,
  stable-pkgs,
  ...
}:
let
  cfg = config.services.media.immich;
in
{
  options.services.media.immich = {
    enable = lib.mkEnableOption "Immich";

    host = lib.mkOption {
      default = "0.0.0.0";
      type = lib.types.nonEmptyStr;
      description = "The ip on which immich is served.";
      example = "192.168.2.5";
    };

    secretsFile = lib.mkOption {
      default = null;
      type = with lib.types; nullOr path;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      services = {
        traefik.dynamicConfigOptions.http = {
          routers.immich = {
            rule = "Host(`immich.${config.homelab.domain}`)";
            service = "immich";
          };
          services.immich.loadBalancer.servers = [
            { url = "http://localhost:${toString config.services.immich.port}"; }
          ];
        };

        immich = {
          enable = true;
          inherit (cfg) secretsFile host;
          package = stable-pkgs.immich;
          openFirewall = true;
        };
      };
    })

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".directories =
        lib.optional cfg.enable config.services.immich.mediaLocation;
    })
  ];
}
