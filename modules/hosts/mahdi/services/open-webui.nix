toplevel@{ den, ... }:
{
  den.aspects.mahdi = {
    includes = [ (den.batteries.unfree [ "open-webui" ]) ];

    nixos =
      { config, lib, ... }:
      let
        domain = "open-webui.${config.networking.domain}";
        inherit (config.lib.securityHeader) mkCSP mkPP;
      in
      lib.mkMerge [
        (lib.mkIf config.services.open-webui.enable {
          sops.templates."open-webui.env".content = ''
            OAUTH_CLIENT_SECRET=${config.sops.placeholder."kanidm/oauth2/open-webui"}
          '';

          services.nginx.virtualHosts.${domain} = {
            enableACME = true;
            acmeRoot = null;
            onlySSL = true;
            kTLS = true;
            locations =
              let
                inherit (config.services.open-webui) host port;
                proxyPass = "http://[${host}]:${toString port}";
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
                    img-src = [
                      "self"
                      "data:"
                    ];
                    font-src = "self";
                    connect-src = "self";
                    style-src = [
                      "self"
                      "unsafe-inline"
                    ];
                    script-src = [
                      "self"
                    ];
                    script-src-elem = [
                      "self"
                      "sha256-IwbGmoRaOLT2V3cavVXQBCapN9X3Jy2mX1vd0rYDIHI="
                      "sha256-0hNLbvbST7rRlQ4OTVBLFpOktWuZU0Xqs3dLVQEpfGo="
                      "sha256-l2tE40TYf1YdqU3c2thwSlpWfR/rB5RLN+vxI6xWWCU="
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
        })
        {
          services.open-webui = {
            enable = true;
            host = "::1";
            port = 11111;
            environmentFile = config.sops.templates."open-webui.env".path;
            environment =
              let
                OAUTH_CLIENT_ID = "open-webui";
              in
              {
                WEBUI_URL = "https://${domain}";

                OLLAMA_BASE_URLS =
                  let
                    local = lib.optional config.services.ollama.enable "http://${config.services.ollama.host}:${toString config.services.ollama.port}";
                    instances = local ++ config.lib.ai.getOtherOllamaUrls;
                    hasInstances = instances != [ ];
                  in
                  lib.warnIf (!hasInstances) "Open-webui missing Ollama endpoints" (
                    lib.mkIf hasInstances (builtins.concatStringsSep ";" instances)
                  );

                SHOW_ADMIN_DETAILS = "False";

                ENABLE_SIGNUP_PASSWORD_CONFIRMATION = "True";
                ENABLE_SIGNUP = "False";
                ENABLE_LOGIN_FORM = "False";
                DEFAULT_USER_ROLE = "user";

                ENABLE_OAUTH_SIGNUP = "True"; # Not the same as ENABLE_SIGNUP
                OAUTH_UPDATE_PICTURE_ON_LOGIN = "True";
                ENABLE_OAUTH_PERSISTENT_CONFIG = "False"; # That's why we are using NixOS ;)
                OAUTH_MERGE_ACCOUNTS_BY_EMAIL = "True";
                OAUTH_UPDATE_NAME_ON_LOGIN = "True";
                OAUTH_UPDATE_EMAIL_ON_LOGIN = "True";

                inherit OAUTH_CLIENT_ID;
                OPENID_PROVIDER_URL = "${config.services.kanidm.server.settings.origin}/oauth2/openid/${OAUTH_CLIENT_ID}/.well-known/openid-configuration";
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

                ENABLE_IMAGE_GENERATION = "True";

                RAG_FULL_CONTEXT = "True";
                ENABLE_RAG_LOCAL_WEB_FETCH = "True";
                ENABLE_WEB_SEARCH = "True";
                ENABLE_RAG_WEB_SEARCH = "True";
                WEB_SEARCH_ENGINE = "duckduckgo";
              }
              // (
                let
                  searxInstances =
                    toplevel.config.flake.nixosConfigurations
                    |> builtins.attrValues
                    |> map (cfg: cfg.config)
                    |> builtins.filter (cfg: cfg.services.searx.enable)
                    |> map (cfg: cfg.services.searx.settings.server.base_url);
                in
                if searxInstances == [ ] then
                  builtins.warn "No SearXNG instance is available for ${config.networking.hostName}'s Open-Webui" { }
                else
                  {
                    WEB_SEARCH_ENGINE = "searxng";
                    SEARXNG_QUERY_URL = "${builtins.head searxInstances}/search?q=<query>";
                  }
              );
          };
        }
      ];
  };
}
