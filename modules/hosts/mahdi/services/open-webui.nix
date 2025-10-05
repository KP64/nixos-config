toplevel: {
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      services.traefik.dynamicConfigOptions.http = {
        routers.open-webui = {
          rule = "Host(`${config.services.open-webui.environment.WEBUI_URL}`)";
          service = "open-webui";
        };
        services.open-webui.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.open-webui.port}"; }
        ];
      };

      # TODO: Complete Setup
      services.open-webui = {
        enable = true;
        port = 11111;
        environment = {
          WEBUI_URL = "open-webui.${config.networking.domain}";

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

          OLLAMA_BASE_URLS = builtins.concatStringsSep ";" [
            # TODO: Declarative IP of Desktop
            "http://192.168.2.221:${toString toplevel.config.flake.nixosConfigurations.aladdin.config.services.ollama.port}"
            "http://localhost:${toString config.services.ollama.port}"
          ];

          RAG_FULL_CONTEXT = "True";
          ENABLE_RAG_LOCAL_WEB_FETCH = "True";
        };
      };
    };
}
