{ config, lib, ... }:
let
  cfg = config.services.media.invidious;
in
{
  options.services.media.invidious.enable = lib.mkEnableOption "Invidious";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      services = {
        traefik.dynamicConfigOptions.http = {
          routers.invidious = {
            rule = "Host(`invidious.${config.networking.domain}`)";
            service = "invidious";
          };
          services.invidious.loadBalancer.servers = [
            { url = "http://localhost:${toString config.services.invidious.port}"; }
          ];
        };

        invidious = {
          enable = true;
          sig-helper.enable = true;
          port = 3344;
          address = "127.0.0.1";
          settings = {
            external_port = "443";
            domain = "invidious.${config.networking.domain}";
            check_tables = true;
            https_only = true;
            colorize_logs = true;
            cache_annotation = true;
            default_user_preferences.save_player_pos = true;
          };
        };
      };
    })

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".directories =
        lib.optional cfg.enable "/var/lib/private/invidious";
    })
  ];
}
