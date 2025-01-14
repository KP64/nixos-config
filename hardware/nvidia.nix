{
  lib,
  config,
  ...
}:
{
  options.hardware.nvidia.enable = lib.mkEnableOption "Nvidia drivers";

  config = lib.mkIf config.hardware.nvidia.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware = {
      nvidia.open = false;
      nvidia-container-toolkit.enable = true;
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
  };
}
