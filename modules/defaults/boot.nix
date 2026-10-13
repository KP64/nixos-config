{
  den.default.nixos = { config, ... }: {
    boot = {
      binfmt.preferStaticEmulators = true;
      bootspec.enableValidation = true;
      tmp.cleanOnBoot = true;
      loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot = {
          enable = config.hardware.facter.report.uefi.supported;
          editor = false;
          bootCounting.enable = true;
        };
      };
    };
  };
}
