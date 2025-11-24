{ inputs, ... }:
{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      imports = [ inputs.harmonia.nixosModules.harmonia ];

      services.nginx.virtualHosts."cache.${config.networking.domain}" = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        locations."/" = {
          proxyPass = "http://${config.services.harmonia-dev.cache.settings.bind}";
        };
      };

      sops.secrets.harmonia-key = { };

      services.harmonia-dev = {
        daemon.enable = true;
        cache = {
          enable = true;
          signKeyPaths = [ config.sops.secrets.harmonia-key.path ];
          settings.bind = "unix:/run/harmonia/harmonia.socket";
        };
      };
    };
}
