{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      services.traefik.dynamicConfigOptions.http = {
        routers.komga = {
          rule = "Host(`komga.${config.networking.domain}`)";
          service = "komga";
        };
        services.komga.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.komga.settings.server.port}"; }
        ];
      };

      # TODO: Add Library -> Multimedia?
      services.komga = {
        enable = true;
        settings = {
          server.port = 25600;
          # TODO: Enable when ready
          komga.oauth2-account-creation = false;
        };
      };
    };
}
