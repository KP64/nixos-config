{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      services.nginx.virtualHosts."komga.${config.networking.domain}" = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.komga.settings.server.port}";
        };
      };

      services.komga = {
        enable = true;
        settings = {
          server.port = 25600;
          komga.oauth2-account-creation = false;
        };
      };
    };
}
