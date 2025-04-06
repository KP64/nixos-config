{ lib, pkgs, ... }:
{
  imports = [ ./efi.nix ];

  config.boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;
    tmp.cleanOnBoot = lib.mkDefault true;
  };
}
