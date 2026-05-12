{ den, inputs, ... }:
{

  flake-file.inputs.lanzaboote = {
    type = "github";
    owner = "nix-community";
    repo = "lanzaboote";
    inputs = {
      nixpkgs.follows = "nixpkgs";
      pre-commit.follows = "";
    };
  };

  # TODO: Research measured boot
  den.aspects.secure-boot = {
    includes = [ den.aspects.efi ];
    nixos =
      { lib, pkgs, ... }:
      {
        imports = [ inputs.lanzaboote.nixosModules.default ];

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
  };
}
