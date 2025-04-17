{ config, lib, ... }:
let
  cfg = config.hardware.networking;
in
{
  options.hardware.networking.enable = lib.mkEnableOption "Networkmanager";

  config.networking.networkmanager = {
    inherit (cfg) enable;
    enableStrongSwan = true;
    ethernet.macAddress = "random";
    wifi.macAddress = "random";
  };
}
