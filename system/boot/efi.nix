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
      supportedFilesystems = [ "btrfs" ];
      # tmp.cleanOnBoot = true;
      loader = {
        efi.canTouchEfiVariables = true;
        grub = {
          enable = true;
          efiSupport = true;
          # efiInstallAsRemovable = true;
        };
        # systemd-boot = {
        #   enable = true;
        #   editor = false;
        #   configurationLimit = 15;
        # };
      };
    };
  };
}
