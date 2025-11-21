{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      services.nginx.virtualHosts."komga.${config.networking.domain}" = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.komga.settings.server.port}";
        };
      };

      services.komga = {
        enable = true;
        settings = {
          server.port = 25600;
          komga = {
            oauth2-account-creation = true;
            oidc-email-verification = false;
          };

          spring.security.oauth2.client = {
            registration.kanidm = {
              provider = "kanidm";
              client-id = "komga";
              client-name = "kanidm";
              scope = "openid,email";
              authorization-grant-type = "authorization_code";
              redirect-uri = "{baseUrl}/{action}/oauth2/code/{registrationId}";
              client-authentication-method = "none";
            };
            provider.kanidm = {
              user-name-attribute = "sub";
              issuer-uri = "${config.services.kanidm.serverSettings.origin}/oauth2/openid/komga";
            };
          };
        };
      };
    };
}
