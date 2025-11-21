{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      services.nginx.virtualHosts."vaultwarden.${config.networking.domain}" = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        locations."/" = {
          proxyWebsockets = true;
          proxyPass = "http://localhost:${toString config.services.vaultwarden.config.ROCKET_PORT}";
        };
      };

      sops.secrets."vaultwarden.env" = { };

      # TODO: Implement OAuth once it is stabilized
      #        - Enable Signups
      services.vaultwarden = {
        enable = true;
        environmentFile = config.sops.secrets."vaultwarden.env".path;
        config = {
          ROCKET_ADDRESS = "::1";
          ROCKET_PORT = 8222;
          ENABLE_WEBSOCKET = true;
          DOMAIN = "https://vaultwarden.${config.networking.domain}";

          PUSH_ENABLED = false;

          SIGNUPS_ALLOWED = false;
          INVITATIONS_ALLOWED = false;
          INVITATION_EXPIRATION_HOURS = 24;
          EMERGENCY_ACCESS_ALLOWED = true;
          EMAIL_CHANGE_ALLOWED = true;
          PASSWORD_HINTS_ALLOWED = true;
          SHOW_PASSWORD_HINT = false;

          LOGIN_RATELIMIT_SECONDS = 60;
          LOGIN_RATELIMIT_MAX_BURST = 10;

          DISABLE_2FA_REMEMBER = false;
          AUTHENTICATOR_DISABLE_TIME_DRIFT = true;
        };
      };
    };
}
