{ inputs, ... }:
let
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
    trusted-users = [ "@wheel" ];
  };
in
{

  flake.modules = {
    nixos.nix =
      { pkgs, ... }:
      {
        nix = {
          package = pkgs.nixVersions.latest;
          settings = commonSettings;
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

        # FIXME: Cache invalidation
        # Populating both Nix Settings in Home-Manager and NixOS
        # causes the Substituters and keys to conflict and
        # be marked as untrusted. WHY THE F*CK THO?
        # This invalidates the cache causing everything to compile from source.
        # NOTE: ONLY Include this if Home-Manager isn't used as a module
        nix = lib.mkIf (osConfig == null) {
          package = lib.mkDefault pkgs.nixVersions.latest;
          settings = commonSettings;
        };

        programs = {
          nix-index.enable = true;
          nix-index-database.comma.enable = true;
          nix-init.enable = true;
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
