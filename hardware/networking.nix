{ lib, config, ... }:
{
  options.hardware.networking.enable = lib.mkEnableOption "Networkmanager";

  config = lib.mkIf config.hardware.networking.enable {
    networking.networkmanager = {
      enable = true;
      enableStrongSwan = true;
      ethernet.macAddress = "random";
      wifi.macAddress = "random";
    };
  };
}
