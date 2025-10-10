{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      services.nginx.virtualHosts."libretranslate.${config.networking.domain}" = {
        useACMEHost = config.networking.domain;
        onlySSL = true;
        kTLS = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.libretranslate.port}";
        };
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
