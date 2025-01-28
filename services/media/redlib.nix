{ config, lib, ... }:
let
  cfg = config.services.media.redlib;
  inherit (config.services.redlib) port;
in
{
  options.services.media.redlib.enable = lib.mkEnableOption "Redlib";

  config = lib.mkIf cfg.enable {
    services = {
      traefik.dynamicConfigOptions.http = {
        routers.redlib = {
          rule = "Host(`redlib.${config.networking.domain}`)";
          service = "redlib";
        };
        services.redlib.loadBalancer.servers = [ { url = "http://localhost:${toString port}"; } ];
      };

      tor.relay.onionServices.redlib.map = [
        {
          port = 80;
          target = {
            addr = "127.0.0.1";
            inherit port;
          };
        }
      ];

      i2pd.inTunnels.redlib = {
        enable = true;
        destination = "127.0.0.1";
        inherit port;
      };

      redlib = {
        enable = true;
        port = 8090;
        settings = {
          REDLIB_DEFAULT_BLUR_SPOILER = "on";
          REDLIB_DEFAULT_SHOW_NSFW = "on";
          REDLIB_DEFAULT_BLUR_NSFW = "on";
        };
      };
    };
  };
}
