toplevel@{ den, ... }:
{
  den.aspects.mahdi = {
    includes = [ den.aspects.secrets._.oauth ];

    nixos =
      { config, lib, ... }:
      lib.mkMerge [
        (lib.mkIf config.services.vaultwarden.enable {
          sops = {
            secrets."vaultwarden/admin-token" = { };
            templates."vaultwarden.env" = {
              owner = config.users.users.vaultwarden.name;
              restartUnits = [ config.systemd.services.vaultwarden.name ];
              content = ''
                ADMIN_TOKEN=${config.sops.placeholder."vaultwarden/admin-token"}
                SSO_CLIENT_SECRET=${config.sops.placeholder."kanidm/oauth2/vaultwarden"}
              '';
            };
          };

          services.caddy.virtualHosts.${config.services.vaultwarden.domain}.extraConfig = # caddy
            ''
              reverse_proxy http://[${config.services.vaultwarden.config.ROCKET_ADDRESS}]:${toString config.services.vaultwarden.config.ROCKET_PORT}
              header {
                  Strict-Transport-Security "max-age=31536000; includeSubDomains"
                  Cross-Origin-Embedder-Policy require-corp
                  Cross-Origin-Opener-Policy same-origin
              }
            '';
        })
        {
          services.vaultwarden = {
            enable = true;
            domain = "vault.${config.networking.domain}";
            environmentFile = config.sops.templates."vaultwarden.env".path;
            config =
              let
                SSO_CLIENT_ID = "vaultwarden";
              in
              {
                ENABLE_WEBSOCKET = true;
                ROCKET_ADDRESS = "::1";
                ROCKET_PORT = 8222;

                LOGIN_RATELIMIT_SECONDS = 60;
                LOGIN_RATELIMIT_MAX_BURST = 10;

                SSO_ENABLED = true;
                SSO_ONLY = true;
                SSO_ALLOW_UNKNOWN_EMAIL_VERIFICATION = true;
                SSO_AUTHORITY = "${toplevel.config.flake.nixosConfigurations.sheherazade.config.services.kanidm.server.settings.origin}/oauth2/openid/${SSO_CLIENT_ID}";
                inherit SSO_CLIENT_ID;
              };
          };
        }
      ];
  };
}
