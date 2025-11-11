{
  flake.modules.nixos.hosts-mahdi =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      services.nginx.virtualHosts."karakeep.${config.networking.domain}" = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        locations."/" = {
          proxyPass = "http://localhost:${config.services.karakeep.extraEnvironment.PORT}";
        };
      };

      services.karakeep = {
        enable = true;
        browser = {
          port = 9222;
          # Default is chromium for whatever reason
          exe = lib.getExe pkgs.ungoogled-chromium;
        };
        extraEnvironment = {
          NEXTAUTH_URL = "https://karakeep.${config.networking.domain}";

          DISABLE_PASSWORD_AUTH = "true";

          OAUTH_WELLKNOWN_URL = "https://${config.services.kanidm.serverSettings.domain}/oauth2/openid/karakeep/.well-known/openid-configuration";
          OAUTH_CLIENT_SECRET = "bogus_secret"; # Needed to work, but isn't actually used. (AS LONG AS IT'S A PUBLIC SERVICE IN KANIDM)
          OAUTH_CLIENT_ID = "karakeep";
          OAUTH_PROVIDER_NAME = "Kanidm";
          OAUTH_ALLOW_DANGEROUS_EMAIL_ACCOUNT_LINKING = "true";

          PORT = "43547";
          RATE_LIMITING_ENABLED = "true";
          DB_WAL_MODE = "true";

          OLLAMA_BASE_URL = "http://localhost:${toString config.services.ollama.port}";
          OLLAMA_KEEP_ALIVE = "5m";
          # NOTE: The whole name is needed.
          #       llama3.2 alone isn't enough.
          INFERENCE_TEXT_MODEL = "llama3.2:3b";
          INFERENCE_IMAGE_MODEL = "gemma3:1b";
          EMBEDDING_TEXT_MODEL = "embeddinggemma:300m";

          CRAWLER_FULL_PAGE_SCREENSHOT = "true";
          CRAWLER_FULL_PAGE_ARCHIVE = "true";
          CRAWLER_VIDEO_DOWNLOAD = "true";
        };
      };
    };
}
