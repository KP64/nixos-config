{ config, lib, ... }:
let
  cfg = config.virt.virtualbox;
in
{
  options.virt.virtualbox.enable = lib.mkEnableOption "Virtualbox";

  config = lib.mkIf cfg.enable {
    boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];

    virtualisation.virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };
  };
}
