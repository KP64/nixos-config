{ config, lib, ... }:
let
  cfg = config.services.misc.forgejo;
in
{
  options.services.misc.forgejo.enable = lib.mkEnableOption "Forgejo";

  config = lib.mkMerge [
    (
      let
        forgejoPort = config.services.forgejo.settings.server.HTTP_PORT;
      in
      lib.mkIf cfg.enable {
        networking.firewall.allowedTCPPorts = [ forgejoPort ];

        services = {
          traefik.dynamicConfigOptions.http = {
            routers.forgejo = {
              rule = "Host(`forgejo.${config.homelab.domain}`)";
              service = "forgejo";
            };
            services.forgejo.loadBalancer.servers = [
              { url = "http://localhost:${toString forgejoPort}"; }
            ];
          };

          forgejo = {
            enable = true;
            dump = {
              enable = true;
              type = "tar";
            };
            lfs.enable = true;
          };
        };

      }
    )

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".directories =
        lib.optional cfg.enable config.services.forgejo.stateDir;
    })
  ];
}
