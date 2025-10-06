{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      services.traefik.dynamicConfigOptions.http = {
        routers.anki = {
          rule = "Host(`anki.${config.networking.domain}`)";
          service = "anki";
        };
        services.anki.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.anki-sync-server.port}"; }
        ];
      };

      # TODO: Move this to User
      sops.secrets."anki/kg" = { };

      services.anki-sync-server = {
        enable = true;
        # TODO: User auto detection. Maybe through sops-nix secrets naming?
        # 
        # NOTE: When using AnkiDroid remember that you need to insert the username
        #       and not the email as instructed. Unless the username is an email ofc...
        users = [
          {
            username = "kg";
            passwordFile = config.sops.secrets."anki/kg".path;
          }
        ];
      };
    };
}
