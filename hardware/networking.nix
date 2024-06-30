{ lib, config, ... }:
{
  options.hardware.networking.enable = lib.mkEnableOption "Enable networkmanager";

  config = lib.mkIf config.hardware.networking.enable { networking.networkmanager.enable = true; };
}
