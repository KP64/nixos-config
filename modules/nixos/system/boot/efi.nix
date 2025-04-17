{ lib, config, ... }:
{
  options.system.boot.efi.enable = lib.mkEnableOption "EFI booting";

  config.boot.loader = lib.mkIf config.system.boot.efi.enable {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      editor = false;
      configurationLimit = 15;
    };
  };
}
