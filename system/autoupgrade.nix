{ lib, config, ... }:
{
  options.system.autoupgrade.enable = lib.mkEnableOption "Enable System Auto Upgrading";

  config = lib.mkIf config.system.autoupgrade.enable {
    system.autoUpgrade = {
      enable = true;
      allowReboot = true;
      flake = "github:KP64/nixos-config";
    };
  };
}
