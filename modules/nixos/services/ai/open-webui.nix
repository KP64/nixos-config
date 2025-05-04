{ config, lib, ... }:
let
  cfg = config.services.ai.open-webui;
in
{
  options.services.ai.open-webui.enable = lib.mkEnableOption "Open-Webui";

  # TODO: Traefik
  config.services.open-webui = {
    inherit (cfg) enable;
    host = "0.0.0.0";
    port = 11111;
    openFirewall = true;
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

}
