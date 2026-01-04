{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      services.nginx.virtualHosts.${config.services.zipline.settings.CORE_DEFAULT_DOMAIN} = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.zipline.settings.CORE_PORT}";
        };
      };

      sops.secrets."zipline.env" = { };

      services.zipline = {
        enable = true;
        environmentFiles = [ config.sops.secrets."zipline.env".path ];
        settings =
          let
            CORE_DEFAULT_DOMAIN = "zipline.${config.networking.domain}";
            OAUTH_OIDC_CLIENT_ID = "zipline";
          in
          {
            CORE_PORT = 41355;
            CORE_SECRET = "$CORE_SECRET";
            CORE_RETURN_HTTPS_URLS = "true";
            inherit CORE_DEFAULT_DOMAIN;
            CORE_RETURN_TRUST_PROXY = "true";

            CHUNKS_ENABLED = "true";

            MFA_PASSKEYS = "true";
            MFA_TOTP_ENABLED = "true";
            MFA_TOTP_ISSUER = "Zipline";

            FEATURES_IMAGE_COMPRESSION = "true";
            FEATURES_ROBOTS_TXT = "true";
            FEATURES_HEALTHCHECK = "true";
            FEATURES_USER_REGISTRATION = "false";
            FEATURES_OAUTH_REGISTRATION = "true";
            FEATURES_DELETE_ON_MAX_VIEWS = "true";
            FEATURES_THUMBNAILS_ENABLED = "true";
            FEATURES_METRICS_ENABLED = "true";
            FEATURES_METRICS_ADMIN_ONLY = "true";
            FEATURES_METRICS_SHOW_USER_SPECIFIC = "true";
            FEATURES_VERSION_CHECKING = "false";

            FILES_ASSUME_MIMETYPES = "true";
            FILES_REMOVE_GPS_METADATA = "true";

            INVITES_ENABLED = "true";

            RATELIMIT_ENABLED = "true";
            RATELIMIT_ADMIN_BYPASS = "true";

            OAUTH_BYPASS_LOCAL_LOGIN = "true";
            inherit OAUTH_OIDC_CLIENT_ID;
            OAUTH_OIDC_CLIENT_SECRET = "$OAUTH_OIDC_CLIENT_SECRET";
            OAUTH_OIDC_AUTHORIZE_URL = "${config.services.kanidm.serverSettings.origin}/ui/oauth2";
            OAUTH_OIDC_USERINFO_URL = "${config.services.kanidm.serverSettings.origin}/oauth2/openid/${OAUTH_OIDC_CLIENT_ID}/userinfo";
            OAUTH_OIDC_TOKEN_URL = "${config.services.kanidm.serverSettings.origin}/oauth2/token";
            OAUTH_OIDC_REDIRECT_URI = "https://${CORE_DEFAULT_DOMAIN}/api/auth/oauth/oidc";
          };
      };
    };
}
