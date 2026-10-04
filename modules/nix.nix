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
      "pipe-operators"
    ];
    substituters = [ "https://nix-community.cachix.org" ];
    trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];

    # TODO: Set to fatal when nixpkgs fixes their stuff.
    lint-absolute-path-literals = "warn";
    lint-short-path-literals = "fatal";
    lint-url-literals = "fatal";

    fsync-store-paths = true;
    preallocate-contents = true;
    # NOTE: Expensive. https://github.com/NixOS/nix/issues/1218#issuecomment-277990880
    sync-before-registering = true;
    use-xdg-base-directories = true;
  };
in
{
  flake-file.inputs.nix-index-database = {
    type = "github";
    owner = "nix-community";
    repo = "nix-index-database";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den = {
    schema.host = { lib, ... }: { options.isServer = lib.mkEnableOption "Machine is a Server"; };

    default = {
      nixos = { host, ... }: { lib, pkgs, ... }: {
        inherit nixpkgs;
        nix = {
          daemonCPUSchedPolicy = if (!host.isServer) then "idle" else "batch";
          daemonIOSchedClass = lib.mkIf (!host.isServer) "idle";
          package = pkgs.nixVersions.latest;
          settings = commonSettings // {
            allowed-users = [ ];
          };
          optimise.automatic = true;
          channel.enable = false;
        };
      };

      homeManager =
        {
          nixosConfig ? null,
          config,
          lib,
          pkgs,
          ...
        }:
        {
          imports = [ inputs.nix-index-database.homeModules.nix-index ];

          config = lib.mkMerge [
            (lib.mkIf (nixosConfig == null) {
              inherit nixpkgs;

              # TODO: Remove once: https://github.com/nix-community/home-manager/pull/5766 or
              #       https://github.com/nix-community/home-manager/pull/9582 is merged
              home.packages = [ config.nix.package ];

              nix = {
                package = pkgs.nixVersions.latest;
                # NOTE: These settings are for the user. If you want to trust users
                #       etc. you will have to manually edit the /etc/nix/nix.conf file
                #       with root permissions.
                settings = commonSettings // {
                  substituters = commonSettings.substituters ++ [ "https://cache.nixos.org/" ];
                  trusted-public-keys = commonSettings.trusted-public-keys ++ [
                    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                  ];
                };
              };
            })
            {
              nix.assumeXdg = nixosConfig != null && commonSettings.use-xdg-base-directories;

              programs = {
                nix-index.enable = true;
                nix-index-database.comma.enable = true;
                direnv = {
                  enable = true;
                  silent = true;
                };
                nh = {
                  enable = true;
                  clean = {
                    enable = true;
                    extraArgs = [
                      "--keep"
                      "5"
                      "--keep-since"
                      "4d"
                    ];
                  };
                  flake = "${config.home.homeDirectory}/nixos-config";
                };
              };
            }
          ];
        };
    };
  };
}
