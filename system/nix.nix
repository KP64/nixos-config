{
  pkgs,
  lib,
  config,
  inputs,
  username,
  ...
}:
let
  cfg = config.system.nix;
in
{
  options.system.nix.extraTrustedUsers = lib.mkOption {
    default = [ ];
    description = "Extra Users to Trust.";
    type = with lib.types; listOf nonEmptyStr;
    example = [
      "alice"
      "bob"
    ];
  };

  config = {
    nix = {
      package = pkgs.nixVersions.latest;
      optimise.automatic = true;
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
          "no-url-literals"
          "pipe-operators"
        ];
        auto-optimise-store = true;
        trusted-users = [ username ] ++ cfg.extraTrustedUsers;
        substituters = [ "https://nix-community.cachix.org" ];
        trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
      };
    };

    environment = lib.mkMerge [
      {
        systemPackages =
          [ inputs.nix-alien.packages.${pkgs.system}.nix-alien ]
          ++ (with pkgs; [
            cachix
            deadnix
            devenv
            fh
            nix-health
            nix-init
            nix-melt
            nix-output-monitor
            nix-tree
            nix-update
            nixfmt-rfc-style
            nixpkgs-lint-community
            nixpkgs-review
            nurl
            nvd
            statix
            vulnix
          ]);
      }

      (lib.mkIf config.isImpermanenceEnabled {
        persistence."/persist".users.${username}.directories = [ ".local/share/direnv" ];
      })
    ];

    home-manager.users.${username} = {
      imports = [ inputs.nix-index-database.hmModules.nix-index ];
      nix.gc.automatic = true;

      programs = {
        nix-index.enable = true;
        nix-index-database.comma.enable = true;
        direnv = {
          enable = true;
          silent = true;
          nix-direnv.enable = true;
        };
      };
    };

    programs = {
      nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep 5 --keep-since 1w";
        };
        flake = "/home/${username}/nixos-config";
      };
      nix-ld.enable = true;
    };
  };
}
