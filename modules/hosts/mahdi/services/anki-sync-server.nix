{ customLib, ... }:
{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      services.nginx.virtualHosts."anki.${config.networking.domain}" = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        locations."/" = {
          proxyPass = "http://[${config.services.anki-sync-server.address}]:${toString config.services.anki-sync-server.port}";
        };
      };

      # NOTE: When using AnkiDroid remember that you need to insert the username
      #       and not the email as instructed. Unless the username is an email ofc...
      services.anki-sync-server = {
        enable = true;
        users = customLib.anki.genUsers config.sops.secrets;
      };
    };
}
