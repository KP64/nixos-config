{ inputs, ... }:
let
  nixpkgs.config = {
    allowAliases = false;
    checkMeta = true;
  };

  commonSettings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
      "no-url-literals"
      "pipe-operators"
    ];
    substituters = [ "https://nix-community.cachix.org" ];
    trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  };
in
{

  flake.modules = {
    nixos.nix =
      { pkgs, ... }:
      {
        inherit nixpkgs;
        nix = {
          package = pkgs.nixVersions.latest;
          settings = commonSettings // {
            trusted-users = [ "@wheel" ];
          };
          optimise.automatic = true;
          channel.enable = false;
        };
      };

    homeManager.nix =
      {
        osConfig ? null,
        config,
        lib,
        pkgs,
        ...
      }:
      {
        imports = [ inputs.nix-index-database.homeModules.nix-index ];

        inherit nixpkgs;
        nix = {
          # when hm is used as a module it syncs the package with the host automatically.
          package = lib.mkIf (osConfig == null) pkgs.nixVersions.latest;
          # NOTE: These settings are for the user. If you want to trust users
          #       etc. you will have to manually edit the /etc/nix/nix.conf file
          #       with root permissions.
          settings = commonSettings // {
            #  WHY THE FUCKING HELL IS THE NIXOS CACHE NOT INCLUDED BY DEFAULT???
            #  Is there a genuine good reason for omitting the cache?
            substituters = commonSettings.substituters ++ [ "https://cache.nixos.org/" ];
            trusted-public-keys = commonSettings.trusted-public-keys ++ [
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            ];
          };
        };

        programs = {
          nix-index.enable = true;
          nix-index-database.comma.enable = true;
          direnv = {
            enable = true;
            silent = true;
            nix-direnv.enable = true;
          };
          nh = {
            enable = true;
            clean = {
              enable = true;
              extraArgs = "--keep 5";
            };
            flake = "${config.home.homeDirectory}/nixos-config";
          };
        };
      };
  };
}
