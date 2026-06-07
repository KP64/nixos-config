{
  # TODO: Reenable immich once mTLS is implemented
  #       and only public proxy is forwarded
  den.aspects.mahdi.nixos =
    { config, lib, ... }:
    lib.mkMerge [
      (lib.mkIf config.services.immich.enable {
        services.nginx.virtualHosts."immich.${config.networking.domain}" = {
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

        users.users.immich.extraGroups = lib.optionals config.hardware.graphics.enable (
          map (group: group.name) (
            with config.users.groups;
            [
              video
              render
            ]
          )
        );

        assertions = [
          {
            assertion =
              (config.services.immich.enable && config.hardware.graphics.enable)
              -> (config.services.immich.accelerationDevices != [ ]);
            message = ''
              You already have graphics. Allow immich to use them.
              To allow all graphics devices set accelerationDevice to null.
              To allow specific devices set accelerationDevice to your preferred devices.
              Note: Devices are under /dev/dri/render...
            '';
          }
        ];
      })
      {
        services.immich = {
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
      }
    ];
}
