{
  flake.aspects.efi.nixos =
    { lib, ... }:
    {
      services.fwupd.enable = lib.mkDefault true;

      boot.loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot = {
          enable = true;
          editor = false;
        };
      };
    };
}
