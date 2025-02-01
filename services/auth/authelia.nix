{ config, lib, ... }:
let
  cfg = config.services.auth.authelia;
in
{
  options.services.auth.authelia.enable = lib.mkEnableOption "Authelia";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      services = {
        # http.routers.<router>.middlewares = [ "authelia@file" ];
        traefik.dynamicConfigOptions.http = {
          middlewares.authelia.forwardAuth = {
            address = "http://localhost:9091/api/verify?auth=basic";
            trustForwardHeader = true;
            authResponseHeaders = map (h: "Remote-${h}") [
              "User"
              "Groups"
              "Email"
              "Name"
            ];
          };
          routers.authelia = {
            rule = "Host(`authelia.${config.networking.domain}`)";
            service = "authelia";
            # service = "authelia@file";
          };
          services.authelia.loadBalancer.servers = [ { url = "http://localhost:9091"; } ];
        };

        authelia.instances =
          let
            inherit (config.sops) secrets;
          in
          {
            # TCP: 9091
            main = {
              enable = true;
              settingsFiles = [ ];
              settings = {
                theme = "auto";
                default_2fa_method = "totp";
                totp.issuer = "authelia.com";

                session.cookies = [
                  {
                    inherit (config.networking) domain;
                    authelia_url = "https://auth.${config.networking.domain}";
                    default_redirection_url = "https://glance.${config.networking.domain}";
                  }
                ];

                regulation.max_retries = 3;
              };
              secrets = {
                storageEncryptionKeyFile = secrets."authelia/storage".path;
                sessionSecretFile = secrets."authelia/session".path;
                oidcIssuerPrivateKeyFile = secrets."authelia/oidc_priv_key".path;
                oidcHmacSecretFile = secrets."authelia/hmac".path;
                jwtSecretFile = secrets."authelia/jwt".path;
              };
              environmentVariables = { };
            };
          };
      };
    })

    # (lib.mkIf config.isImpermanenceEnabled {
    #   environment.persistence."/persist".directories = lib.optional cfg.enable "/var/lib/authelia";
    # })
  ];
}
