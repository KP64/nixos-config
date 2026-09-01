toplevel@{ den, ... }:
{
  den.aspects.mahdi = {
    includes = with den; [
      (batteries.unfree [ "open-webui" ])
      aspects.secrets._.oauth
    ];

    nixos =
      { config, lib, ... }:
      let
        domain = "open-webui.${config.networking.domain}";
        inherit (config.lib.securityHeader) mkCSP;
      in
      lib.mkMerge [
        (lib.mkIf config.services.open-webui.enable {
          sops.templates."open-webui.env" = {
            restartUnits = [ config.systemd.services.open-webui.name ];
            content = ''
              OAUTH_CLIENT_SECRET=${config.sops.placeholder."kanidm/oauth2/open-webui"}
            '';
          };

          services.caddy.virtualHosts.${domain}.extraConfig = # caddy
            ''
              reverse_proxy http://[${config.services.open-webui.host}]:${toString config.services.open-webui.port}
            '';
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

                # Taken from https://docs.openwebui.com/getting-started/advanced-topics/hardening/#security-headers
                HSTS = "max-age=31536000;includeSubDomains";
                XFRAME_OPTIONS = "DENY";
                XCONTENT_TYPE = "nosniff";
                REFERRER_POLICY = "strict-origin-when-cross-origin";
                PERMISSIONS_POLICY = "camera=(),microphone=(),geolocation=()";
                CONTENT_SECURITY_POLICY = mkCSP {
                  default-src = "self";
                  img-src = [
                    "self"
                    "data:"
                  ];
                  style-src = [
                    "self"
                    "unsafe-inline"
                  ];
                  script-src-elem = [
                    "self"
                    "unsafe-inline"
                  ];
                };
                CROSS_ORIGIN_EMBEDDER_POLICY = "require-corp";
                CROSS_ORIGIN_OPENER_POLICY = "same-origin";
                CROSS_ORIGIN_RESOURCE_POLICY = "same-origin";

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
                OPENID_PROVIDER_URL = "${toplevel.config.flake.nixosConfigurations.sheherazade.config.services.kanidm.server.settings.origin}/oauth2/openid/${OAUTH_CLIENT_ID}/.well-known/openid-configuration";
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
