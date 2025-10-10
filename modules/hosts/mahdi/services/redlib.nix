{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      services.nginx.virtualHosts."redlib.${config.networking.domain}" = {
        useACMEHost = config.networking.domain;
        onlySSL = true;
        kTLS = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.redlib.port}";
        };
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
