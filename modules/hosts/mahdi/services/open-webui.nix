toplevel: {
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      services.nginx.virtualHosts."open-webui.${config.networking.domain}" = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        locations = {
          "/" = {
            proxyWebsockets = true;
            proxyPass = "http://localhost:${toString config.services.open-webui.port}";
          };
          "~* ^/(api|oauth|callback|login|ws|websocket)" = {
            proxyWebsockets = true;
            proxyPass = "http://localhost:${toString config.services.open-webui.port}";
            extraConfig = ''
              proxy_no_cache 1;
              proxy_cache_bypass 1;
              proxy_read_timeout 3600s;
              proxy_send_timeout 3600s;
              proxy_set_header Accept-Encoding "";
            '';
          };
        };
      };

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

          SHOW_ADMIN_DETAILS = "False";

          ENABLE_SIGNUP_PASSWORD_CONFIRMATION = "True";
          ENABLE_SIGNUP = "False";
          ENABLE_LOGIN_FORM = "False";
          DEFAULT_USER_ROLE = "user";

          ENABLE_OAUTH_SIGNUP = "True"; # Not the same as ENABLE_SIGNUP
          OAUTH_UPDATE_PICTURE_ON_LOGIN = "True";
          ENABLE_OAUTH_PERSISTENT_CONFIG = "False"; # That's why we are using NixOS ;)
          OAUTH_MERGE_ACCOUNTS_BY_EMAIL = "True";

          OAUTH_CLIENT_ID = "open-webui";
          OPENID_PROVIDER_URL = "https://${config.services.kanidm.serverSettings.domain}/oauth2/openid/open-webui/.well-known/openid-configuration";
          OAUTH_CODE_CHALLENGE_METHOD = "S256";
          OAUTH_PROVIDER_NAME = "kanidm";
          ENABLE_OAUTH_ROLE_MANAGEMENT = "True";
          ENABLE_OAUTH_GROUP_MANAGEMENT = "True";
          ENABLE_OAUTH_GROUP_CREATION = "True";

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
