{ den, inputs, ... }: {
  flake-file.inputs.lanzaboote = {
    type = "github";
    owner = "nix-community";
    repo = "lanzaboote";
    inputs = {
      nixpkgs.follows = "nixpkgs";
      pre-commit.follows = "";
    };
  };

  den.aspects.boot._.secure = {
    includes = [ den.aspects.boot._.efi ];
    nixos =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        inherit (lib) types;
      in
      {
        imports = [ inputs.lanzaboote.nixosModules.default ];

        options.boot.measuredPcrs = lib.mkOption {
          default = [ ];
          type = types.addCheck (types.listOf types.ints.unsigned) (builtins.all (x: x <= 7));
          example = [
            0
            4
            7
          ];
          description = ''
            PCRs owned by the firmware, i.e. PCRs 0–7 are described here just for convenience.
            The authoriative description is in the TCG document.
            https://uapi-group.org/specifications/specs/linux_tpm_pcr_registry/
          '';
        };

        config = {
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
              configurationLimit = lib.mkIf config.boot.lanzaboote.measuredBoot.enable 8;
              measuredBoot = {
                enable = config.boot.lanzaboote.measuredBoot.pcrs != [ ];
                pcrs = config.boot.measuredPcrs;
              };
              autoGenerateKeys.enable = true;
              autoEnrollKeys = {
                enable = true;
                autoReboot = true;
              };
            };
          };
        };
      };
  };
}
