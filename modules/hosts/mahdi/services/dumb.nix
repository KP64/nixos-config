toplevel: {
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      imports = [ toplevel.config.flake.modules.nixos.dumb ];

      services.nginx.virtualHosts."dumb.${config.networking.domain}" = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.dumb.port}";
        };
      };

      services.dumb.enable = true;
    };
}
