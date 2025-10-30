{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      services.nginx.virtualHosts."atuin.${config.networking.domain}" = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.atuin.port}";
        };
      };

      services.atuin = {
        enable = true;
        port = 33196;
        openRegistration = true;
      };
    };
}
