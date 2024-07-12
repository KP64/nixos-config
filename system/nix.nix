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
  options.system.nix = {
    enable = lib.mkEnableOption "Manage nix configuration";
    extraTrustedUsers = lib.mkOption {
      default = [ ];
      description = "Extra Users to Trust.";
      type = with lib.types; listOf str;
    };
  };

  config = lib.mkIf cfg.enable {
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
      with inputs;
      [ nix-alien.packages.${pkgs.system}.nix-alien ]
      ++ (with pkgs; [
        cachix
        nixfmt-rfc-style
        devenv
        fh
        statix
        nurl
        deadnix
        nil
        nvd
        nixpkgs-lint-community
        nix-melt
        nix-output-monitor
        nix-health
        nix-tree
      ]);

    home-manager.users.${username} = {
      imports = with inputs; [ nix-index-database.hmModules.nix-index ];
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
          extraArgs = "--keep 5";
        };
        # TODO: Use 'self.outPath' or './..' ?
        flake = "/home/${username}/Desktop/nixos-config";
      };
      nix-ld = {
        enable = true;
        package = inputs.nix-ld-rs.packages.${pkgs.system}.nix-ld-rs;
      };
    };
  };
}
