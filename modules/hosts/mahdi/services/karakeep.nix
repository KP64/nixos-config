{
  flake.aspects.hosts-mahdi.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      domain = "karakeep.${config.networking.domain}";
      inherit (config.lib.nginx) mkCSP mkPP;
    in
    {
      services = {
        nginx.virtualHosts.${domain} = {
          enableACME = true;
          acmeRoot = null;
          onlySSL = true;
          kTLS = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${config.services.karakeep.extraEnvironment.PORT}";
            extraConfig = # nginx
              ''
                add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
                add_header Content-Security-Policy "${
                  mkCSP {
                    default-src = "none";
                    font-src = "self";
                    img-src = "self";
                    style-src = [
                      "self"
                      "unsafe-inline"
                    ];
                    script-src = [
                      "self"
                      "unsafe-inline"
                    ];
                    connect-src = "self";
                  }
                }" always; 
                add_header X-Frame-Options SAMEORIGIN always;
                add_header X-Content-Type-Options nosniff always;
                add_header Referrer-Policy no-referrer always;
                add_header Permissions-Policy "${
                  mkPP {
                    camera = "()";
                    microphone = "()";
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
        };

        karakeep = {
          enable = true;
          browser = {
            port = 9222;
            # Default is chromium for whatever reason
            exe = lib.getExe pkgs.ungoogled-chromium;
          };
          extraEnvironment =
            let
              OAUTH_CLIENT_ID = "karakeep";
            in
            {
              NEXTAUTH_URL = "https://${domain}";

              DISABLE_PASSWORD_AUTH = "true";

              OAUTH_WELLKNOWN_URL = "${config.services.kanidm.server.settings.origin}/oauth2/openid/${OAUTH_CLIENT_ID}/.well-known/openid-configuration";
              OAUTH_CLIENT_SECRET = "bogus_secret"; # Needed to work, but isn't actually used. (AS LONG AS IT'S A PUBLIC SERVICE IN KANIDM)
              inherit OAUTH_CLIENT_ID;
              OAUTH_PROVIDER_NAME = "Kanidm";
              OAUTH_ALLOW_DANGEROUS_EMAIL_ACCOUNT_LINKING = "true";

              PORT = "43547";
              RATE_LIMITING_ENABLED = "true";
              DB_WAL_MODE = "true";

              OLLAMA_BASE_URL = "http://${config.services.ollama.host}:${toString config.services.ollama.port}";
              OLLAMA_KEEP_ALIVE = "5m";
              # NOTE: The whole name is needed.
              #       llama3.2 alone isn't enough.
              # TODO: Check if model is available. Implement fallback Logic
              #        - Either "force install" model or detect if another suitable is installed.
              INFERENCE_TEXT_MODEL = "llama3.2:3b";
              INFERENCE_IMAGE_MODEL = "gemma3:1b";
              EMBEDDING_TEXT_MODEL = "embeddinggemma:300m";

              CRAWLER_FULL_PAGE_SCREENSHOT = "true";
              CRAWLER_FULL_PAGE_ARCHIVE = "true";
              CRAWLER_VIDEO_DOWNLOAD = "true";
            };
        };
      };
    };
}
