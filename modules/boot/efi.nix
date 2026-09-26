{
  den.aspects.boot._.efi.nixos.boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      editor = false;
    };
  };
}
