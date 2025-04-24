{ config, lib, ... }:
{
  options.hardware.nvidia.enable = lib.mkEnableOption "Nvidia drivers";

  config = lib.mkIf config.hardware.nvidia.enable {
    nixpkgs.config.cudaSupport = true;

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware = {
      nvidia = {
        open = true;
        nvidiaPersistenced = true;
        powerManagement.enable = true;
      };
      nvidia-container-toolkit.enable = true;
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
  };
}
