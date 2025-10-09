{ inputs, ... }:
let
  nixpkgs.config.allowAliases = false;

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
    # NOTE: This isn't recognized by Home-Manager for whatever reason.
    #       This causes Home-Manager to emit A LOT of warnings even though
    #       it still works perfectly fine. Just WTF man.
    # TODO: Open issue about this
    trusted-users = [ "@wheel" ];
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

        config = lib.mkMerge [
          {
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
          }

          # NOTE: ONLY Include this if Home-Manager isn't used as a module.
          (lib.mkIf (osConfig == null) {
            inherit nixpkgs;
            nix = {
              package = pkgs.nixVersions.latest;
              # NOTE: For whatever reason this doesn't come with defaults at all.
              #       Everything must be specified manually.
              settings = {
                inherit (commonSettings) auto-optimise-store experimental-features trusted-users;
                allowed-users = "*";
                cores = 0;
                max-jobs = "auto";
                require-sigs = true;
                sandbox = true;
                sandbox-fallback = false;
                # NOTE: WHY IN THE FUCKING HELL IS THE NIXOS CACHE NOT INCLUDED BY DEFAULT???
                #       At this point I'm just losing my sanity.
                #       Is there a genuine good reason for omitting the cache?
                substituters = commonSettings.substituters ++ [ "https://cache.nixos.org/" ];
                trusted-public-keys = commonSettings.trusted-public-keys ++ [
                  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                ];
              };
            };
          })
        ];
      };
  };
}
