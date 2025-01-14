{
  config,
  lib,
  stable-pkgs,
  ...
}:
let
  cfg = config.services.media.jellyfin;
in
{
  options.services.media.jellyfin.enable = lib.mkEnableOption "Jellyfin";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      services = {
        traefik.dynamicConfigOptions.http = {
          routers.jellyfin = {
            rule = "Host(`jellyfin.${config.networking.domain}`)";
            service = "jellyfin";
          };
          services.jellyfin.loadBalancer.servers = [ { url = "http://localhost:8096"; } ];
        };

        # Unstable needs pipewire which has to
        # compile from Source on aarch64-linux
        jellyfin = {
          enable = true;
          package = stable-pkgs.jellyfin;
          group = "multimedia";
        };
      };
    })

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".directories =
        lib.optional cfg.enable config.services.jellyfin.dataDir;
    })
  ];
}
