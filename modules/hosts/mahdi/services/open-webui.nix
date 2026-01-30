toplevel: {
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    let
      domain = "open-webui.${config.networking.domain}";
      inherit (toplevel.config.flake.nixos) mkCSP mkPP;
    in
    {
      allowedUnfreePackages = [ "open-webui" ];

      services = {
        nginx.virtualHosts.${domain} = {
          enableACME = true;
          acmeRoot = null;
          onlySSL = true;
          kTLS = true;
          locations =
            let
              inherit (config.services.open-webui) host port;
              proxyPass = "http://${host}:${toString port}";
            in
            {
              "/" = {
                proxyWebsockets = true;
                inherit proxyPass;
              };
              "~* ^/(api|oauth|callback|login|ws|websocket)" = {
                proxyWebsockets = true;
                inherit proxyPass;
                extraConfig = ''
                  proxy_no_cache 1;
                  proxy_cache_bypass 1;
                  proxy_read_timeout 3600s;
                  proxy_send_timeout 3600s;
                  proxy_set_header Accept-Encoding "";
                '';
              };
            };
          extraConfig = # nginx
            ''
              add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
              add_header Content-Security-Policy "${
                mkCSP {
                  default-src = "none";
                  img-src = "self";
                  font-src = "self";
                  connect-src = "self";
                  style-src = [
                    "self"
                    "unsafe-inline"
                  ];
                  script-src = [
                    "self"
                    "unsafe-inline"
                  ];
                }
              }" always;
              add_header X-Frame-Options SAMEORIGIN always;
              add_header X-Content-Type-Options nosniff always;
              add_header Referrer-Policy no-referrer always;
              add_header Permissions-Policy "${
                mkPP {
                  camera = "()";
                  geolocation = "()";
                  usb = "()";
                  bluetooth = "()";
                  payment = "()";
                  accelerometer = "()";
                  gyroscope = "()";
                  magnetometer = "()";
                  midi = "()";
                  serial = "()";
                  hid = "()";
                }
              }" always;
            '';
        };

        open-webui = {
          enable = true;
          port = 11111;
          environment =
            let
              OAUTH_CLIENT_ID = "open-webui";
              inherit (toplevel.config.flake.nixosConfigurations) aladdin;
            in
            {
              WEBUI_URL = "https://${domain}";

              OLLAMA_BASE_URLS = builtins.concatStringsSep ";" [
                # TODO: Declarative IP of Desktop
                "http://192.168.2.221:${toString aladdin.config.services.ollama.port}"
                "http://${config.services.ollama.host}:${toString config.services.ollama.port}"
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

              inherit OAUTH_CLIENT_ID;
              OPENID_PROVIDER_URL = "${config.services.kanidm.serverSettings.origin}/oauth2/openid/${OAUTH_CLIENT_ID}/.well-known/openid-configuration";
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

              # TODO: Image Generation. No need for comfyui anymore.
              #       Ollama supports image gen (note its experimental)
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
    };
}
