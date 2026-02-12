{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      # TODO: Use immich public proxy
      services = {
        # nginx.virtualHosts."immich.${config.networking.domain}" = {
        #   enableACME = true;
        #   acmeRoot = null;
        #   onlySSL = true;
        #   kTLS = true;
        #   locations."/" = {
        #     proxyPass = "http://${config.services.immich.host}:${toString config.services.immich.port}";
        #     proxyWebsockets = true;
        #     extraConfig = ''
        #       client_max_body_size 50000M;
        #       proxy_read_timeout   600s;
        #       proxy_send_timeout   600s;
        #       send_timeout         600s;
        #     '';
        #   };
        # };

        immich = {
          enable = true;
          settings = {
            passwordLogin.enabled = false;
            oauth =
              let
                clientId = "immich";
              in
              {
                autoLaunch = true;
                inherit clientId;
                enabled = true;
                issuerUrl = "${config.services.kanidm.server.settings.origin}/oauth2/openid/${clientId}";
                signingAlgorithm = "ES256";
              };
          };
        };
      };
    };
}
