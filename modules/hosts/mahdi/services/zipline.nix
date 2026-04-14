{ moduleWithSystem, ... }:
{
  flake.modules.nixos.hosts-mahdi = moduleWithSystem (
    { config, ... }:
    nixos@{ lib, ... }:
    let
      cfg = nixos.config.services.zipline;
      kanidmOrigin = nixos.config.services.kanidm.server.settings.origin;
      inherit (nixos.config.lib.securityHeader) mkCSP mkPP;
    in
    lib.mkMerge [
      (lib.mkIf nixos.config.services.zipline.enable {
        sops = {
          secrets."zipline/core-secret" = { };
          templates."zipline.env".content = ''
            CORE_SECRET=${nixos.config.sops.placeholder."zipline/core-secret"}
            OAUTH_OIDC_CLIENT_SECRET=${nixos.config.sops.placeholder."kanidm/oauth2/zipline"}
          '';
        };

        services.nginx.virtualHosts.${cfg.settings.CORE_DEFAULT_DOMAIN} = {
          enableACME = true;
          acmeRoot = null;
          onlySSL = true;
          kTLS = true;
          locations."/" = {
            proxyPass = "http://[${cfg.settings.CORE_HOSTNAME}]:${toString cfg.settings.CORE_PORT}";
            extraConfig = # nginx
              ''
                add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
                add_header Content-Security-Policy "${
                  mkCSP {
                    default-src = "none";
                    style-src = [
                      "self"
                      "unsafe-inline"
                    ];
                    img-src = [
                      "self"
                      "https://getsharex.com"
                      "https://raw.githubusercontent.com"
                    ];
                    connect-src = "self";
                    script-src = [
                      "self"
                      "unsafe-eval"
                    ];
                    font-src = [
                      "self"
                      "data:"
                    ];
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
      })
      {

        services.zipline = {
          enable = true;
          package = config.packages.zipline;
          environmentFiles = [ nixos.config.sops.templates."zipline.env".path ];
          settings =
            let
              inherit (lib) boolToString;
              CORE_DEFAULT_DOMAIN = "zipline.${nixos.config.networking.domain}";
              OAUTH_OIDC_CLIENT_ID = "zipline";
            in
            {
              CORE_HOSTNAME = "::1";
              CORE_PORT = 41355;
              CORE_RETURN_HTTPS_URLS = boolToString true;
              inherit CORE_DEFAULT_DOMAIN;
              CORE_RETURN_TRUST_PROXY = boolToString true;

              CHUNKS_ENABLED = boolToString true;

              MFA_PASSKEYS = boolToString true;
              MFA_TOTP_ENABLED = boolToString true;
              MFA_TOTP_ISSUER = "Zipline";

              FEATURES_IMAGE_COMPRESSION = boolToString true;
              FEATURES_ROBOTS_TXT = boolToString true;
              FEATURES_HEALTHCHECK = boolToString true;
              FEATURES_USER_REGISTRATION = boolToString false;
              FEATURES_OAUTH_REGISTRATION = boolToString true;
              FEATURES_DELETE_ON_MAX_VIEWS = boolToString true;
              FEATURES_THUMBNAILS_ENABLED = boolToString true;
              FEATURES_METRICS_ENABLED = boolToString true;
              FEATURES_METRICS_ADMIN_ONLY = boolToString true;
              FEATURES_METRICS_SHOW_USER_SPECIFIC = boolToString true;
              FEATURES_VERSION_CHECKING = boolToString false;

              FILES_ASSUME_MIMETYPES = boolToString true;
              FILES_REMOVE_GPS_METADATA = boolToString true;

              INVITES_ENABLED = boolToString true;

              RATELIMIT_ENABLED = boolToString true;
              RATELIMIT_ADMIN_BYPASS = boolToString true;

              OAUTH_BYPASS_LOCAL_LOGIN = boolToString true;
              inherit OAUTH_OIDC_CLIENT_ID;
              OAUTH_OIDC_AUTHORIZE_URL = "${kanidmOrigin}/ui/oauth2";
              OAUTH_OIDC_USERINFO_URL = "${kanidmOrigin}/oauth2/openid/${OAUTH_OIDC_CLIENT_ID}/userinfo";
              OAUTH_OIDC_TOKEN_URL = "${kanidmOrigin}/oauth2/token";
              OAUTH_OIDC_REDIRECT_URI = "https://${CORE_DEFAULT_DOMAIN}/api/auth/oauth/oidc";
            };
        };
      }
    ]
  );
}
