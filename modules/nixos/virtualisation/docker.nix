{ config, lib, ... }:
let
  cfg = config.virt.docker;
in
{
  options.virt.docker.enable = lib.mkEnableOption "Docker";

  config.virtualisation = lib.mkIf cfg.enable {
    oci-containers.backend = "docker";
    docker = {
      autoPrune.enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
