toplevel: {
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      services.traefik.dynamicConfigOptions.http = {
        routers.open-webui = {
          rule = "Host(`open-webui.${config.networking.domain}`)";
          service = "open-webui";
        };
        services.open-webui.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.open-webui.port}"; }
        ];
      };

      # TODO: Set CORS_ALLOW_ORIGIN
      services.open-webui = {
        enable = true;
        port = 11111;
        environment = {
          WEBUI_URL = "https://open-webui.${config.networking.domain}";

          OLLAMA_BASE_URLS = builtins.concatStringsSep ";" [
            # TODO: Declarative IP of Desktop
            "http://192.168.2.221:${toString toplevel.config.flake.nixosConfigurations.aladdin.config.services.ollama.port}"
            "http://localhost:${toString config.services.ollama.port}"
          ];

          # TODO: Do this when Mail Server is set up
          SHOW_ADMIN_DETAILS = "False";
          # ADMIN_EMAIL = "";
          ENABLE_SIGNUP_PASSWORD_CONFIRMATION = "True";
          OAUTH_UPDATE_PICTURE_ON_LOGIN = "True";

          RESET_CONFIG_ON_START = "True";
          ENABLE_OPENAI_API = "False";
          ENABLE_VERSION_UPDATE_CHECK = "False";

          ENABLE_CHANNELS = "True";
          ENABLE_REALTIME_CHAT_SAVE = "True";

          ENABLE_API_KEY_ENDPOINT_RESTRICTIONS = "True";
          ENABLE_FORWARD_USER_INFO_HEADERS = "True";

          PDF_EXTRACT_IMAGES = "True";

          # TODO: Image Generation (Comfyui)
          ENABLE_IMAGE_GENERATION = "True";

          RAG_FULL_CONTEXT = "True";
          ENABLE_RAG_LOCAL_WEB_FETCH = "True";
          ENABLE_WEB_SEARCH = "True";
          ENABLE_RAG_WEB_SEARCH = "True";
          WEB_SEARCH_ENGINE = "searxng";
          SEARXNG_QUERY_URL = "${config.services.searx.settings.server.base_url}/search?q=<query>";
        };
      };
    };
}
