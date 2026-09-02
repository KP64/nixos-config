toplevel: {
  den.aspects.mahdi.nixos =
    { config, ... }:
    let
      domain = "immich.${config.networking.domain}";
      inherit (config.lib.securityHeader) mkCSP mkPP;
    in
    {
      services.caddy.virtualHosts.${domain}.extraConfig = # caddy
        ''
          reverse_proxy http://[${config.services.immich.host}]:${toString config.services.immich.port}
          header {
              Strict-Transport-Security "max-age=31536000; includeSubDomains"
              X-Frame-Options SAMEORIGIN
              X-Content-Type-Options nosniff
              Referrer-Policy no-referrer
              Cross-Origin-Embedder-Policy require-corp
              Cross-Origin-Opener-Policy same-origin
              Cross-Origin-Resource-Policy same-origin
              Content-Security-Policy "${
                mkCSP {
                  default-src = "none";
                  img-src = [
                    "self"
                    "data:"
                  ];
                  font-src = "self";
                  style-src-elem = [
                    "self"
                    "unsafe-inline"
                  ];
                  style-src-attr = "unsafe-inline";
                  script-src-elem = [
                    "self"
                    "unsafe-inline"
                  ];
                  connect-src = [
                    "self"
                    "https://static.immich.cloud"
                    "https://tiles.immich.cloud"
                  ];
                  worker-src = [
                    "self"
                    "blob:"
                  ];
                }
              }"
              Permissions-Policy "${
                mkPP {
                  geolocation = "()";
                  microphone = "()";
                  camera = "()";
                }
              }"
          }
        '';

      # TODO: Add public Proxy and mTLS.
      services.immich = {
        enable = true;
        host = "::1";
        settings = {
          metadata.faces.import = true;
          passwordLogin.enabled = false;
          server.externalDomain = "https://${domain}";
          oauth =
            let
              clientId = "immich";
            in
            {
              enabled = true;
              autoRegister = true;
              inherit clientId;
              clientSecret._secret = config.sops.secrets."kanidm/oauth2/immich".path;
              issuerUrl = "${toplevel.config.flake.nixosConfigurations.sheherazade.config.services.kanidm.server.settings.origin}/oauth2/openid/${clientId}";
              signingAlgorithm = "ES256";
              roleclaim = "immich_role";
            };
        };
      };
    };
}
