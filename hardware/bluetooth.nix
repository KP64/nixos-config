{ lib, config, ... }:

{
  options.hardware.bluetoothctl.enable = lib.mkEnableOption "Enable Bluetooth";

  config = lib.mkIf config.hardware.bluetoothctl.enable {
    hardware.bluetooth = {
      enable = true;
      settings.General.Experimental = true;
    };
  };
}
