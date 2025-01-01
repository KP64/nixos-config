{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.virt.virtualbox;
in
{
  options.virt.virtualbox.enable = lib.mkEnableOption "Virtualbox";

  config = lib.mkMerge [
    {
      boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];

      users.extraGroups.vboxusers.members = [ username ];
      virtualisation.virtualbox.host = {
        inherit (cfg) enable;
        enableExtensionPack = true;
      };
    }

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".users.${username}.directories = lib.optionals cfg.enable [
        "VirtualBox VMs"
        ".config/VirtualBox"
      ];
    })
  ];
}
