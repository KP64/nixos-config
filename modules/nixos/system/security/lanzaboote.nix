{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.system.security.secure-boot;
in
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  options.system.security.secure-boot.enable = lib.mkEnableOption "Lanzaboote";

  config = lib.mkMerge [
    { environment.systemPackages = [ pkgs.sbctl ]; }

    (lib.mkIf cfg.enable {
      boot = {
        # Lanzaboote currently replaces the systemd-boot module.
        # This setting is usually set to true in configuration.nix
        # generated at installation time. So we force it to false
        # for now.
        loader.systemd-boot.enable = lib.mkForce false;
        lanzaboote = {
          enable = true;
          pkiBundle = "/var/lib/sbctl";
        };
      };
    })
  ];
}
