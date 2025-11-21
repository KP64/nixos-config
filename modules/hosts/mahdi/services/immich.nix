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
          proxyWebsockets = true;
          extraConfig = ''
            client_max_body_size 50000M;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;
          '';
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
            issuerUrl = "${config.services.kanidm.serverSettings.origin}/oauth2/openid/immich";
            signingAlgorithm = "ES256";
          };
        };
      };
    };
}
