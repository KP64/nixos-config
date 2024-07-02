{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  options.system.security.secure-boot.enable = lib.mkEnableOption "Enable Lanzaboote for Secure Boot";

  imports = with inputs; [ lanzaboote.nixosModules.lanzaboote ];
  config = lib.mkIf config.system.security.secure-boot.enable {
    environment.systemPackages = with pkgs; [ sbctl ];
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
  };
}
