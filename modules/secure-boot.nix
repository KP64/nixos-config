toplevel@{ inputs, ... }:
{
  flake.modules.nixos.secure-boot =
    { lib, pkgs, ... }:
    {
      imports = [
        inputs.lanzaboote.nixosModules.default
        toplevel.config.flake.modules.nixos.efi
      ];

      environment.systemPackages = [ pkgs.sbctl ];

      boot = {
        # Lanzaboote currently replaces the systemd-boot module.
        # This setting is usually set to true in configuration.nix
        # generated at installation time.
        # So we force it to false for now.
        loader.systemd-boot.enable = lib.mkForce false;
        lanzaboote = {
          enable = true;
          pkiBundle = "/var/lib/sbctl";
          autoGenerateKeys.enable = true;
          autoEnrollKeys = {
            enable = true;
            autoReboot = true;
          };
        };
      };
    };
}
