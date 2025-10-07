{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      services.traefik.dynamicConfigOptions.http = {
        routers.libretranslate = {
          rule = "Host(`${config.services.libretranslate.domain}`)";
          service = "libretranslate";
        };
        services.libretranslate.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.libretranslate.port}"; }
        ];
      };

      # NOTE: To manage API keys use the "ltmanage-keys" cli command.
      # TODO: Get rid of trademark warning
      services.libretranslate = {
        enable = true;
        port = 33305;
        domain = "libretranslate.${config.networking.domain}";
        # updateModels = true; # FIXME: Doesn't work
        enableApiKeys = true;
      };
    };
}
