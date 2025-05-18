{ config, lib, ... }:
let
  cfg = config.services.media.invidious;
  inherit (config.services.invidious) port;
in
{
  options.services.media.invidious.enable = lib.mkEnableOption "Invidious";

  config.services = lib.mkIf cfg.enable {
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
      domain = "invidious.${config.networking.domain}";
      settings = {
        external_port = 443;
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
}
