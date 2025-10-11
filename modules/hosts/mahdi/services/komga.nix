{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      services.nginx.virtualHosts."komga.${config.networking.domain}" = {
        enableACME = true;
        onlySSL = true;
        kTLS = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.komga.settings.server.port}";
        };
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
