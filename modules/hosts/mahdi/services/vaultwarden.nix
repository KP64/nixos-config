{
  flake.modules.nixos.hosts-mahdi =
    { config, lib, ... }:
    {
      sops.secrets."vaultwarden.env".owner = config.users.users.vaultwarden.name;

      services = {
        nginx.virtualHosts.${config.services.vaultwarden.domain} = {
          enableACME = true;
          acmeRoot = null;
          forceSSL = lib.mkForce false; # This is configured by `configureNginx`
          onlySSL = true;
          kTLS = true;
          extraConfig = # nginx
            ''
              add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
            '';
        };

        vaultwarden = {
          enable = true;
          domain = "vaultwarden.${config.networking.domain}";
          configureNginx = true;
          environmentFile = config.sops.secrets."vaultwarden.env".path;
          config =
            let
              SSO_CLIENT_ID = "vaultwarden";
            in
            {
              LOGIN_RATELIMIT_SECONDS = 60;
              LOGIN_RATELIMIT_MAX_BURST = 10;

              SSO_ENABLED = true;
              SSO_ONLY = true;
              SSO_ALLOW_UNKNOWN_EMAIL_VERIFICATION = true;
              SSO_AUTHORITY = "${config.services.kanidm.serverSettings.origin}/oauth2/openid/${SSO_CLIENT_ID}";
              inherit SSO_CLIENT_ID;
              SSO_CLIENT_SECRET = "bogus";
            };
        };
      };
    };
}
