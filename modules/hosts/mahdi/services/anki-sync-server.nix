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
          proxyPass = "http://127.0.0.1:${toString config.services.anki-sync-server.port}";
        };
      };

      # Here are users that aren't part of the Nix Config.
      sops.secrets."anki/jeffyjeff" = { };

      # NOTE: When using AnkiDroid remember that you need to insert the username
      #       and not the email as instructed. Unless the username is an email ofc...
      services.anki-sync-server = {
        enable = true;
        users = customLib.anki.genUsers config.sops.secrets;
      };
    };
}
