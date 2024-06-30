{ lib, config, ... }:

{
  options.hardware.blue.enable = lib.mkEnableOption "Enable Bluetooth";

  config = lib.mkIf config.hardware.blue.enable {
    hardware.bluetooth = {
      enable = true;
      settings.General.Experimental = true;
    };
  };
}
