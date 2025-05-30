{ config, lib, ... }:
let
  cfg = config.services.misc.anki;
  inherit (config.services.anki-sync-server) port;
in
{
  options.services.misc.anki = {
    enable = lib.mkEnableOption "Anki";
    users = lib.mkOption {
      default = [ ];
      type = with lib.types; listOf attrs;
      description = "The users who connect to the server.";
      example = [
        {
          username = "John";
          password = "12345";
        }
      ];
    };
  };

  config.services = lib.mkIf cfg.enable {
    traefik.dynamicConfigOptions.http = {
      routers.anki = {
        rule = "Host(`anki.${config.networking.domain}`)";
        service = "anki";
      };
      services.anki.loadBalancer.servers = [ { url = "http://localhost:${toString port}"; } ];
    };

    anki-sync-server = {
      enable = true;
      inherit (cfg) users;
    };
  };
}
