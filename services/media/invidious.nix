{ config, lib, ... }:
let
  cfg = config.services.media.invidious;
  port = config.services.invidious.port;
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
          services.invidious.loadBalancer.servers = [ { url = "http://localhost:${toString port}"; } ];
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

        tor.relay.onionServices.invidious.map = [
          {
            port = 80;
            target = {
              addr = "127.0.0.1";
              inherit port;
            };
          }
        ];

        i2pd.inTunnels.invidious = {
          enable = true;
          destination = "127.0.0.1";
          inherit port;
        };
      };
    })

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".directories =
        lib.optional cfg.enable "/var/lib/private/invidious";
    })
  ];
}
