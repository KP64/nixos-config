{
  # TODO: Reenable once oauth proxy is implemented
  flake.modules.nixos.hosts-mahdi =
    { config, lib, ... }:
    {
      services.nginx.virtualHosts."scrutiny.${config.networking.domain}" =
        lib.mkIf config.services.scrutiny.enable
          {
            enableACME = true;
            acmeRoot = null;
            onlySSL = true;
            kTLS = true;
            locations."/" = {
              proxyPass = config.services.scrutiny.settings.api.endpoint;
            };
          };

      services.scrutiny = {
        enable = false;
        settings.web.listen.port = 44617;
      };
    };
}
