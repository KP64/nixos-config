{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      services.nginx.virtualHosts."immich.${config.networking.domain}" = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.immich.port}";
        };
      };

      services.immich = {
        enable = true;
        settings = {
          passwordLogin.enabled = false;
          oauth = {
            autoLaunch = true;
            clientId = "immich";
            enabled = true;
            issuerUrl = "https://${config.services.kanidm.serverSettings.domain}/oauth2/openid/immich";
            signingAlgorithm = "ES256";
          };
        };
      };
    };
}
