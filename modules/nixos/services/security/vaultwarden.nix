{ config, lib, ... }:
let
  cfg = config.services.security.vaultwarden;
in
{
  options.services.security.vaultwarden.enable = lib.mkEnableOption "Vaultwarden";

  config = lib.mkIf cfg.enable {
    services = {
      traefik.dynamicConfigOptions.http = {
        routers.vaultwarden = {
          rule = "Host(`vaultwarden.${config.networking.domain}`)";
          service = "vaultwarden";
        };
        services.vaultwarden.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.vaultwarden.config.ROCKET_PORT}"; }
        ];
      };

      vaultwarden = {
        enable = true;
        environmentFile = config.sops.secrets."vaultwarden.env".path;
        config = {
          SIGNUPS_ALLOWED = true;
          SIGNUPS_VERIFY = true;

          ROCKET_ADDRESS = "::1";
          ROCKET_PORT = 8222;
          DOMAIN = "https://vaultwarden.${config.networking.domain}";
        };
      };
    };
  };
}
