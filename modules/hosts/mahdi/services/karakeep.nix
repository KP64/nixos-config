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
        useACMEHost = config.networking.domain;
        onlySSL = true;
        kTLS = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.karakeep.extraEnvironment.PORT}";
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
          PORT = "43547";
          RATE_LIMITING_ENABLED = "true";
          DB_WAL_MODE = "true";
          DISABLE_SIGNUPS = "true";

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
