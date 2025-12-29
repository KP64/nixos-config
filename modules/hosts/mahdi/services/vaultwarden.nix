{
  flake.modules.nixos.hosts-mahdi =
    { config, lib, ... }:
    {
      services.nginx.virtualHosts.${config.services.vaultwarden.domain} = {
        enableACME = true;
        acmeRoot = null;
        forceSSL = lib.mkForce false; # This is configured by `configureNginx`
        onlySSL = true;
        kTLS = true;
      };

      sops.secrets."vaultwarden.env" = { };

      # TODO: Package the newest version until it is in nixpkgs
      # TODO: Implement OAuth once it is stabilized
      #        - Enable Signups
      services.vaultwarden = {
        enable = true;
        domain = "vaultwarden.${config.networking.domain}";
        configureNginx = true;
        environmentFile = config.sops.secrets."vaultwarden.env".path;
        config = {
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
