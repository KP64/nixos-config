{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.system.boot.efi.enable = lib.mkEnableOption "Enable efi booting.";

  config = lib.mkIf config.system.boot.efi.enable {
    boot = {
      kernelPackages = pkgs.linuxPackages_zen;
      tmp.cleanOnBoot = true;
      loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot = {
          enable = true;
          configurationLimit = 15;
        };
      };
    };
  };
}
