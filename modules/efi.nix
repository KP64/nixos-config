{
  flake.modules.nixos.efi = {
    services.fwupd.enable = true;

    boot.loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = false;
      };
    };
  };
}
