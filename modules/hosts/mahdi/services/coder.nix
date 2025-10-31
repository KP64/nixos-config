{
  flake.modules.nixos.hosts-mahdi =
    { config, pkgs, ... }:
    let
      port = 45467;
    in
    {
      services.nginx.virtualHosts."coder.${config.networking.domain}" = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        locations."/" = {
          proxyWebsockets = true;
          proxyPass = "http://localhost:${toString port}";
        };
      };

      virtualisation.docker = {
        enable = true;
        rootless = {
          enable = true;
          setSocketVariable = true;
        };
        autoPrune.enable = true;
      };

      # Doesn't have permission to access the socket otherway
      users.users.coder.extraGroups = [ "docker" ];

      sops.secrets."coder.env" = { };

      services.coder = {
        enable = true;
        package = pkgs.coder.override { channel = "mainline"; };
        accessUrl = "https://coder.${config.networking.domain}";
        wildcardAccessUrl = "*.coder.${config.networking.domain}";
        listenAddress = "127.0.0.1:${toString port}";
        environment = {
          file = config.sops.secrets."coder.env".path;
          extra = {
            CODER_BLOCK_DIRECT = "1";
            # NOTE: You need to disable this for the first time
            #       in order to be able to create the admin account.
            #       You will have to change the auth type in the
            #       settings after you have logged in.
            #       Then you can disable password auth once again.
            CODER_DISABLE_PASSWORD_AUTH = "1";
            CODER_DISABLE_SESSION_EXPIRY_REFRESH = "1";
            CODER_SECURE_AUTH_COOKIE = "1";
            CODER_STRICT_TRANSPORT_SECURITY = "31536000";

            CODER_OAUTH2_GITHUB_ALLOW_SIGNUPS = "0";
            CODER_OAUTH2_GITHUB_DEFAULT_PROVIDER_ENABLE = "0";

            CODER_OIDC_SIGN_IN_TEXT = "Sign in with Kanidm";
            CODER_OIDC_ISSUER_URL = "https://${config.services.kanidm.serverSettings.domain}/oauth2/openid/coder";
            CODER_OIDC_CLIENT_ID = "coder";
            CODER_OIDC_IGNORE_EMAIL_VERIFIED = "1";
          };
        };
      };
    };
}
