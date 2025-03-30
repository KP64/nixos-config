{ config, lib, ... }:
let
  cfg = config.services.media.stirling-pdf;

  port = config.services.stirling-pdf.environment.SERVER_PORT;
  stirlingPort = toString port;
in
{
  options.services.media.stirling-pdf.enable = lib.mkEnableOption "Stirling-pdf";

  config = lib.mkIf cfg.enable {
    services = {
      traefik.dynamicConfigOptions.http = {
        routers.stirling-pdf = {
          rule = "Host(`stirling-pdf.${config.networking.domain}`)";
          service = "stirling-pdf";
        };
        services.stirling-pdf.loadBalancer.servers = [ { url = "http://localhost:${stirlingPort}"; } ];
      };

      stirling-pdf = {
        enable = true;
        environment.SERVER_PORT = 4300;
      };

      tor.relay.onionServices.stirling-pdf.map = [
        {
          port = 80;
          target = {
            addr = "127.0.0.1";
            inherit port;
          };
        }
      ];

      i2pd.inTunnels.stirling-pdf = {
        enable = true;
        destination = "127.0.0.1";
        inherit port;
      };
    };
  };
}
