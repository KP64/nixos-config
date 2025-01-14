{ config, lib, ... }:
let
  cfg = config.services.misc.atuin;
in
{
  options.services.misc.atuin.enable = lib.mkEnableOption "Atuin";

  config = lib.mkIf cfg.enable {
    services = {
      traefik.dynamicConfigOptions.http = {
        routers.atuin = {
          rule = "Host(`atuin.${config.networking.domain}`)";
          service = "atuin";
        };
        services.atuin.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.atuin.port}"; }
        ];
      };

      atuin = {
        enable = true;
        port = 8070;
        openRegistration = true;
      };
    };
  };
}
