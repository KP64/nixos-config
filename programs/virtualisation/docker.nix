{ lib, config, ... }:
{
  options.virt.docker.enable = lib.mkEnableOption "Docker";

  config = lib.mkIf config.virt.docker.enable {
    virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
