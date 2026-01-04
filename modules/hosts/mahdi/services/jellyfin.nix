{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      services.nginx.virtualHosts."jellyfin.${config.networking.domain}" = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8096"; # HTTP WebUI Port
        };
      };

      services.jellyfin.enable = true;
    };
}
