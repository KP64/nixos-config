{ config, lib, ... }:
let
  cfg = config.hardware.networking;
in
{
  options.hardware.networking.enable = lib.mkEnableOption "Networkmanager";

  config.networking.networkmanager = {
    inherit (cfg) enable;
    enableStrongSwan = true;
    # TODO: Reenable
    # ethernet.macAddress = "random";
    # wifi.macAddress = "random";
  };
}
