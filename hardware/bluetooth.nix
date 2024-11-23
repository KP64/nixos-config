{ lib, config, ... }:

{
  options.hardware.bluetoothctl.enable = lib.mkEnableOption "Bluetooth";

  config = lib.mkIf config.hardware.bluetoothctl.enable {
    hardware.bluetooth = {
      enable = true;
      settings.General.Experimental = true;
    };
  };
}
