{ lib, config, ... }:
{
  options.apps.virtualisation.docker.enable = lib.mkEnableOption "Enables Docker";

  config = lib.mkIf config.apps.virtualisation.docker.enable {
    virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
