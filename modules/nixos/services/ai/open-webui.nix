{ config, lib, ... }:
let
  cfg = config.services.ai.open-webui;

  inherit (config.services.open-webui) port;
in
{
  options.services.ai.open-webui.enable = lib.mkEnableOption "Open-Webui";

  config.services = lib.mkIf cfg.enable {
    traefik.dynamicConfigOptions.http = {
      routers.open-webui = {
        rule = "Host(`open-webui.${config.networking.domain}`)";
        service = "open-webui";
      };
      services.open-webui.loadBalancer.servers = [ { url = "http://localhost:${toString port}"; } ];
    };

    open-webui = {
      inherit (cfg) enable;
      host = "0.0.0.0";
      port = 11111;
      environment = {
        ANONYMIZED_TELEMETRY = "False";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";

        WEBUI_AUTH = "False";

        DEFAULT_USER_ROLE = "user";

        ENABLE_RAG_WEB_SEARCH = "True";
        ENABLE_SEARCH_QUERY = "True";
        RAG_WEB_SEARCH_ENGINE = "duckduckgo";
      };
    };
  };
}
