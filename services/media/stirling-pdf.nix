{ config, lib, ... }:
let
  cfg = config.services.media.stirling-pdf;
  port = 4300;
  stirlingPort = toString port;
in
{
  options.services.media.stirling-pdf.enable = lib.mkEnableOption "Stirling-pdf";

  # Docker Container to bypass weird build failures
  # with the nixpkgs module
  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.stirling-pdf = {
      image = "stirlingtools/stirling-pdf:latest";
      ports = [ "${stirlingPort}:8080" ];
      volumes = map (p: "./StirlingPDF/${p}") [
        "trainingData:/usr/share/tessdata"
        "extraConfigs:/configs"
        "customFiles:/customFiles/"
        "logs:/logs/"
        "pipeline:/pipeline/"
      ];
      environment = {
        DOCKER_ENABLE_SECURITY = "false";
        LANGS = "de_DE";
      };
    };

    services = {
      traefik.dynamicConfigOptions.http = {
        routers.stirling-pdf = {
          rule = "Host(`stirling-pdf.${config.networking.domain}`)";
          service = "stirling-pdf";
        };
        services.stirling-pdf.loadBalancer.servers = [ { url = "http://localhost:${stirlingPort}"; } ];
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
