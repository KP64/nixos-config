{ lib, config, ... }:
{
  options.virt.docker.enable = lib.mkEnableOption "Enables Docker";

  config = lib.mkIf config.virt.docker.enable {
    virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
