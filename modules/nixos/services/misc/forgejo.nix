{ config, lib, ... }:
let
  inherit (config.services) misc forgejo;
  cfg = misc.forgejo;
in
{
  options.services.misc.forgejo.enable = lib.mkEnableOption "Forgejo";

  config.services = lib.mkIf cfg.enable {
    traefik.dynamicConfigOptions.http =
      let
        inherit (forgejo) domain settings;
      in
      {
        routers.git = {
          rule = "Host(`${domain}`)";
          service = "git";
        };
        services.git.loadBalancer.servers = [
          { url = "http://localhost:${toString settings.server.HTTP_PORT}"; }
        ];
      };

    forgejo = {
      enable = true;
      settings.server.DOMAIN = "git.${config.networking.domain}";
      dump = {
        enable = true;
        type = "tar";
      };
      lfs.enable = true;
    };
  };
}
