{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  options.system.security.secure-boot.enable = lib.mkEnableOption "Lanzaboote";

  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];
  config = lib.mkMerge [
    { environment.systemPackages = [ pkgs.sbctl ]; }

    (lib.mkIf config.system.security.secure-boot.enable {
      environment.persistence."/persist".directories = lib.optional config.system.impermanence.enable config.boot.lanzaboote.pkiBundle;

      boot = {
        # Lanzaboote currently replaces the systemd-boot module.
        # This setting is usually set to true in configuration.nix
        # generated at installation time. So we force it to false
        # for now.
        loader.systemd-boot.enable = lib.mkForce false;
        lanzaboote = {
          enable = true;
          pkiBundle = "/etc/secureboot";
        };
      };
    })
  ];
}
