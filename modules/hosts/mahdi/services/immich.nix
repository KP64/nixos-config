{
<<<<<<< HEAD
  flake.aspects.hosts-mahdi.nixos =
    { config, ... }:
=======
  # TODO: Reenable immich once mTLS is implemented
  #       and only public proxy is forwarded
  flake.modules.nixos.hosts-mahdi =
    { config, lib, ... }:
>>>>>>> main
    {
      services = {
        # TODO: Hardening
        nginx.virtualHosts."immich.${config.networking.domain}" = lib.mkIf config.services.immich.enable {
          enableACME = true;
          acmeRoot = null;
          onlySSL = true;
          kTLS = true;
          locations."/" = {
            proxyPass = "http://${config.services.immich.host}:${toString config.services.immich.port}";
            proxyWebsockets = true;
            extraConfig = ''
              client_max_body_size 50000M;
              proxy_read_timeout   600s;
              proxy_send_timeout   600s;
              send_timeout         600s;
            '';
          };
        };

        immich = {
          enable = false;
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
