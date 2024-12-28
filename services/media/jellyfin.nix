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
    {
      # Unstable needs pipewire which has to
      # compile from Source on aarch64-linux
      services.jellyfin = {
        inherit (cfg) enable;
        openFirewall = true;
        package = stable-pkgs.jellyfin;
        group = "multimedia";
      };
    }

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".directories =
        lib.optional cfg.enable config.services.jellyfin.dataDir;
    })
  ];
}
