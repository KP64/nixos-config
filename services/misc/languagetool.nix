{ config, lib, ... }:
let
  cfg = config.services.misc.languagetool;
in
{
  options.services.misc.languagetool.enable = lib.mkEnableOption "Languagetool";

  config = lib.mkIf cfg.enable {
    services = {
      traefik.dynamicConfigOptions.http = {
        routers.languagetool = {
          rule = "Host(`languagetool.${config.networking.domain}`)";
          service = "languagetool";
        };
        services.languagetool.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.languagetool.port}"; }
        ];
      };

      languagetool = {
        enable = true;
        public = true;
      };
    };
  };
}
