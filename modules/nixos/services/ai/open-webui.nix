{ config, lib, ... }:
let
  inherit (config.services) ai open-webui ollama;

  cfg = ai.open-webui;

  inherit (open-webui) port;

  domain = "open-webui.${config.networking.domain}";
in
{
  options.services.ai.open-webui = {
    enable = lib.mkEnableOption "Open-Webui";

    ollamaUrls = lib.mkOption {
      default = [ "http://localhost:${toString ollama.port}" ];
      type = with lib.types; nonEmptyListOf nonEmptyStr;
      description = "The Model Providers.";
    };
  };

  config.services = lib.mkIf cfg.enable {
    traefik.dynamicConfigOptions.http = {
      routers.open-webui = {
        rule = "Host(`${domain}`)";
        service = "open-webui";
      };
      services.open-webui.loadBalancer.servers = [ { url = "http://localhost:${toString port}"; } ];
    };

    # TODO: RAG & Image Generation
    open-webui = {
      inherit (cfg) enable;
      port = 11111;
      environment = {
        WEBUI_URL = domain;

        SHOW_ADMIN_DETAILS = "False";
        RESET_CONFIG_ON_START = "True";

        OAUTH_UPDATE_PICTURE_ON_LOGIN = "True";

        RAG_EMBEDDING_MODEL_AUTO_UPDATE = "False";
        RAG_RERANKING_MODEL_AUTO_UPDATE = "False";

        ENABLE_CHANNELS = "True";
        ENABLE_REALTIME_CHAT_SAVE = "True";

        ENABLE_API_KEY_ENDPOINT_RESTRICTIONS = "True";
        ENABLE_FORWARD_USER_INFO_HEADERS = "True";

        ENABLE_WEB_SEARCH = "True";
        WEB_SEARCH_ENGINE = "duckduckgo";

        PDF_EXTRACT_IMAGES = "True";
        BYPASS_WEB_SEARCH_EMBEDDING_AND_RETRIEVAL = "True";

        ENABLE_IMAGE_GENERATION = "True";

        OLLAMA_BASE_URLS = builtins.concatStringsSep ";" cfg.ollamaUrls;

        RAG_FULL_CONTEXT = "True";
        ENABLE_RAG_LOCAL_WEB_FETCH = "True";
      };
    };
  };
}
