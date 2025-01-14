{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.hardware.intel.enable = lib.mkEnableOption "Intel drivers";

  config = lib.mkIf config.hardware.intel.enable {
    hardware = {
      intel-gpu-tools.enable = true;
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          intel-media-driver
          intel-compute-runtime
          vpl-gpu-rt
        ];
      };
    };
  };
}
