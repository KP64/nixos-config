{
  pkgs,
  lib,
  config,
  inputs,
  stable-pkgs,
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
    type = with lib.types; listOf str;
  };

  config = {
    nix = {
      channel.enable = true; # ? Rust-Analyzer Needs it
      optimise.automatic = true;
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        auto-optimise-store = true;
        trusted-users = [
          "root"
          username
        ] ++ cfg.extraTrustedUsers;
      };
    };

    environment.systemPackages =
      [ inputs.nix-alien.packages.${pkgs.system}.nix-alien ]
      ++ [ stable-pkgs.nix-melt ]
      ++ (with pkgs; [
        cachix
        deadnix
        devenv
        fh
        nil
        nix-health
        nix-init
        nix-output-monitor
        nix-tree
        nixfmt-rfc-style
        nixpkgs-lint-community
        nurl
        nvd
        statix
      ]);

    home-manager.users.${username} = {
      imports = [ inputs.nix-index-database.hmModules.nix-index ];
      nix.gc.automatic = true;
      home.sessionVariables.DIRENV_LOG_FORMAT = "";
      programs = {
        nix-index.enable = true;
        nix-index-database.comma.enable = true;
        direnv = {
          enable = true;
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
