{ inputs, ... }:
{
  flake.modules.nixos."hosts/aladdin" = {
    imports = [ inputs.nixos-facter-modules.nixosModules.facter ];

    facter.reportPath = ./facter.json;

    system.stateVersion = "25.11";

    boot.loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 15;
      };
    };
  };
}
