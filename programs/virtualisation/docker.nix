{ lib, config, ... }:
let
  cfg = config.virt.docker;
in
{
  options.virt.docker.enable = lib.mkEnableOption "Docker";

  config.virtualisation.docker.rootless = {
    inherit (cfg) enable;
    setSocketVariable = true;
  };
}
