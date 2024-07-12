{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.hardware.nvidia.enable = lib.mkEnableOption "Enable Nvidia drivers.";

  config = lib.mkIf config.hardware.nvidia.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware = {
      nvidia = {
        powerManagement.enable = true;
        modesetting.enable = true;
      };
      nvidia-container-toolkit.enable = true;
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [ nvidia-vaapi-driver ];
      };
    };
  };
}
