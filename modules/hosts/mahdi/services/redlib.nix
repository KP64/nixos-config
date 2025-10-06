{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      services.traefik.dynamicConfigOptions.http = {
        routers.redlib = {
          rule = "Host(`redlib.${config.networking.domain}`)";
          service = "redlib";
        };
        services.redlib.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.redlib.port}"; }
        ];
      };

      services.redlib = {
        enable = true;
        port = 41297;
        settings = {
          REDLIB_ROBOTS_DISABLE_INDEXING = true;
          REDLIB_ENABLE_RSS = true;
          # REDLIB_FULL_URL = ""; # TODO: Needed by RSS?

          REDLIB_DEFAULT_BLUR_SPOILER = true;
          REDLIB_DEFAULT_SHOW_NSFW = true;
          REDLIB_DEFAULT_BLUR_NSFW = true;
        };
      };
    };
}
