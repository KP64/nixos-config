toplevel@{ moduleWithSystem, ... }:
{
  den.aspects.mahdi = {
    nixos = moduleWithSystem (
      { system, ... }: { config, ... }: {
        sops.secrets."oauth2-proxy/cookie-secret" = { };

        services.nginx.virtualHosts.${config.services.oauth2-proxy.nginx.domain} = {
          enableACME = true;
          acmeRoot = null;
          onlySSL = true;
          kTLS = true;
        };

        services.oauth2-proxy =
          let
            inherit (toplevel.config.flake.nixosConfigurations) sheherazade;
            inherit (sheherazade.config.services) kanidm;
            clientID = "oauth2-proxy";
          in
          {
            enable = true;

            extraConfig = {
              code-challenge-method = "S256";
              cookie-samesite = "strict";
              whitelist-domain = [ ".${config.networking.domain}" ];
            };

            provider = "oidc";
            oidcIssuerUrl = "${kanidm.server.settings.origin}/oauth2/openid/${clientID}";
            inherit clientID;
            clientSecretFile = config.sops.secrets."kanidm/oauth2/oauth2-proxy".path;
            redirectURL = "https://${config.services.oauth2-proxy.nginx.domain}/oauth2/callback";
            email.domains = [ "*" ];

            cookie = {
              domain = ".${config.networking.domain}";
              secretFile = config.sops.secrets."oauth2-proxy/cookie-secret".path;
            };
            setXauthrequest = true;
            passAccessToken = true;
            reverseProxy = true;
            trustedProxyIP = [
              "127.0.0.0/8"
              "::1/128"
              toplevel.config.flake.topology.${system}.config.networks.home.cidrv6
            ];
            nginx = {
              domain = "oauth2-proxy.${config.networking.domain}";
              virtualHosts = {
                "navidrome.${config.networking.domain}".allowed_groups = [ "access_navidrome" ];
              };
            };
          };
      }
    );
  };
}
