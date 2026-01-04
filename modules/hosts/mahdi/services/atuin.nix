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
          proxyPass = "http://127.0.0.1:${toString config.services.atuin.port}";
        };
      };

      services.atuin = {
        enable = true;
        port = 33196;
        openRegistration = true;
      };
    };
}
