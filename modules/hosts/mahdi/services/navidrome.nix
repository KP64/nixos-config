{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      services.nginx.virtualHosts."navidrome.${config.networking.domain}" = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.navidrome.settings.Port}";
        };
      };

      sops.secrets."navidrome.env" = { };

      services.navidrome = {
        enable = true;
        environmentFile = config.sops.secrets."navidrome.env".path;
        settings = {
          BaseUrl = "https://navidrome.${config.networking.domain}";
          SearchFullString = true;
        };
      };
    };
}
