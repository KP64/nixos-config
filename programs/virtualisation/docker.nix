{
  lib,
  config,
  pkgs,
  username,
  ...
}:
let
  cfg = config.virt.docker;
in
{
  options.virt.docker.enable = lib.mkEnableOption "Docker";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      environment.systemPackages = [ pkgs.lazydocker ];

      virtualisation = {
        oci-containers.backend = "docker";
        docker = {
          autoPrune.enable = true;
          rootless = {
            enable = true;
            setSocketVariable = true;
          };
        };
      };

      users.users.${username}.extraGroups = [ "docker" ];
    })

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".directories = lib.optional cfg.enable {
        directory = "/var/lib/docker";
        mode = "0710";
      };
    })
  ];
}
