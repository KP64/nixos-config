{
  flake.modules.nixos.hosts-mahdi =
    { config, pkgs, ... }:
    {
      services.nginx.virtualHosts."coder.${config.networking.domain}" = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        locations."/" = {
          proxyWebsockets = true;
          proxyPass = "http://${config.services.coder.listenAddress}";
        };
      };

      allowedUnfreePackages = [ "terraform" ];

      # TODO: Use rootless docker or switch to podman
      virtualisation.docker = {
        enable = true;
        autoPrune.enable = true;
      };

      # Doesn't have permission to access the socket otherway
      users.users.coder.extraGroups = [ "docker" ];

      sops.secrets."coder.env" = { };

      systemd.services.coder.after = [ "kanidm.service" ];

      services.coder = {
        enable = true;
        package = pkgs.coder.override { channel = "mainline"; };
        accessUrl = "https://coder.${config.networking.domain}";
        wildcardAccessUrl = "*.coder.${config.networking.domain}";
        listenAddress = "127.0.0.1:45467";
        environment = {
          file = config.sops.secrets."coder.env".path;
          extra =
            let
              CODER_OIDC_CLIENT_ID = "coder";
            in
            {
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
              CODER_OIDC_ISSUER_URL = "${config.services.kanidm.serverSettings.origin}/oauth2/openid/${CODER_OIDC_CLIENT_ID}";
              inherit CODER_OIDC_CLIENT_ID;
              CODER_OIDC_IGNORE_EMAIL_VERIFIED = "1";
              CODER_OIDC_GROUP_AUTO_CREATE = "1";
              CODER_OIDC_ALLOW_SIGNUPS = "1";
              CODER_OIDC_ICON_URL = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/kanidm-light.svg";
            };
        };
      };
    };
}
