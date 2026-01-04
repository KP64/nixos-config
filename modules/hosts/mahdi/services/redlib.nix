{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    let
      domain = "redlib.${config.networking.domain}";
    in
    {
      services.nginx.virtualHosts.${domain} = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.redlib.port}";
        };
      };

      services.redlib = {
        enable = true;
        port = 41297;
        settings = {
          REDLIB_ROBOTS_DISABLE_INDEXING = true;
          REDLIB_ENABLE_RSS = true;
          REDLIB_FULL_URL = "https://${domain}";
          REDLIB_DEFAULT_BLUR_SPOILER = true;
          REDLIB_DEFAULT_SHOW_NSFW = true;
          REDLIB_DEFAULT_BLUR_NSFW = true;
        };
      };
    };
}
