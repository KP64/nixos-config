{ config, lib, ... }:
let
  cfg = config.hardware.bluetoothctl;
in
{
  options.hardware.bluetoothctl.enable = lib.mkEnableOption "Bluetooth";

  config.hardware.bluetooth = {
    inherit (cfg) enable;
    settings.General.Experimental = true;
  };
}
