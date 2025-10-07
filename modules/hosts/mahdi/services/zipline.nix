{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      services.traefik.dynamicConfigOptions.http = {
        routers.zipline = {
          rule = "Host(`${config.services.zipline.settings.CORE_DEFAULT_DOMAIN}`)";
          service = "zipline";
        };
        services.zipline.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.zipline.settings.CORE_PORT}"; }
        ];
      };

      sops.secrets."zipline.env" = { };

      # TODO: Enable OAuth
      services.zipline = {
        enable = true;
        environmentFiles = [ config.sops.secrets."zipline.env".path ];
        settings = {
          CORE_PORT = 41355;
          CORE_SECRET = "$CORE_SECRET";

          CORE_RETURN_HTTPS_URLS = "true";
          CORE_DEFAULT_DOMAIN = "zipline.${config.networking.domain}";
          CORE_RETURN_TRUST_PROXY = "true";

          MFA_PASSKEYS = "true";
          MFA_TOTP_ENABLED = "true";
          MFA_TOTP_ISSUER = "Zipline";

          FEATURES_IMAGE_COMPRESSION = "true";
          FEATURES_ROBOTS_TXT = "true";
          FEATURES_HEALTHCHECK = "true";
          FEATURES_USER_REGISTRATION = "true";
          FEATURES_OAUTH_REGISTRATION = "true";
          FEATURES_DELETE_ON_MAX_VIEWS = "true";
          FEATURES_THUMBNAILS_ENABLED = "true";
          FEATURES_METRICS_ENABLED = "true";
          FEATURES_METRICS_ADMIN_ONLY = "true";
          FEATURES_VERSION_CHECKING = "true";

          FILES_ASSUME_MIMETYPES = "true";
          FILES_REMOVE_GPS_METADATA = "true";

          INVITES_ENABLED = "true";

          RATELIMIT_ENABLED = "true";
          RATELIMIT_ADMIN_BYPASS = "true";
        };
      };
    };
}
