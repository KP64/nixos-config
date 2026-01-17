{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    let
      cfg = config.services.uptime-kuma;
    in
    {
      services.nginx.virtualHosts."uptime.${config.networking.domain}" = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        locations."/".proxyPass = "http://${cfg.settings.HOST}:${toString cfg.settings.PORT}";
      };

      services.uptime-kuma = {
        enable = true;
        appriseSupport = true;
      };
    };
}
