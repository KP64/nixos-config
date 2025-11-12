{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      services.nginx.virtualHosts.${config.services.libretranslate.domain} = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
      };

      # NOTE: To manage API keys use the "ltmanage-keys" cli command.
      # TODO: Get rid of trademark warning
      services.libretranslate = {
        enable = true;
        port = 33305;
        domain = "libretranslate.${config.networking.domain}";
        configureNginx = true;
        updateModels = true;
        enableApiKeys = true;
      };
    };
}
