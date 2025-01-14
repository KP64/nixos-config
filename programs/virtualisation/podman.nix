{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.virt.podman;
in
{
  options.virt.podman.enable = lib.mkEnableOption "Podman";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
        autoPrune.enable = true;
        defaultNetwork.settings.dns_enabled = true;
      };

      users.users.${username}.extraGroups = [ "podman" ];
    })

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".directories = lib.optional cfg.enable "/var/lib/containers";
    })
  ];
}
