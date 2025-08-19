{
  description = "KP64's Ultimate Nixos ❄️";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Everything Catppuccin 😺
    catppuccin.url = "github:catppuccin/nix";

    # Periodic NixOS config update service
    # Especially important for Servers
    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disk partitioning
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Self-Made colorscript
    dotz = {
      url = "github:KP64/dotz";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    # Just for deduplication of inputs
    flake-compat.url = "github:edolstra/flake-compat";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    systems.url = "github:nix-systems/default";

    # Bind everything together
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Manage Dotfiles
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secure boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Realtime Audio
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Latest neovim version
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    # Run unpatched Binaries
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs = {
        flake-compat.follows = "flake-compat";
        nix-index-database.follows = "nix-index-database";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Weekly updated nix pkgs database
    # Useful for https://github.com/nix-community/comma
    # and replacing command-not-found
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Stuff that shouldn't be visible to the naked eye,
    # but shouldn't or can't be encrypted
    nix-invisible = {
      url = "git+ssh://git@github.com/KP64/nix-invisible";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Advanced minecraft Server configuration
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # NixOS in Android via termux
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    # Network Topology
    nix-topology = {
      url = "github:oddlama/nix-topology";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # VSCode extensions not
    # packaged by nixpkgs
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Declarative Discord
    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Nix managed Neovim
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    # Better hardware-configuration "replacement"
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

    # NixOS on Windows via WSL
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # AUR Nix edition
    nur = {
      url = "github:nix-community/nur";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Firefox Hardening
    better-fox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative Spotify
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    # Format repos with style
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = with inputs; [
        treefmt-nix.flakeModule
        nix-topology.flakeModule
        nixvim.flakeModules.default
        home-manager.flakeModules.home-manager
      ];

      flake =
        let
          globals = import "${inputs.nix-invisible}/globals.nix";

          rootPath = inputs.self.outPath;
          lib = nixpkgs.lib.extend (
            _: _: inputs.home-manager.lib // { custom = import ./lib { inherit inputs rootPath; }; }
          );

          common = {
            homeManager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-backup";
              sharedModules = [ ./modules/home ];
            };

            specialArgs = hostName: invisible: {
              inherit
                inputs
                hostName
                rootPath
                invisible
                ;
            };
          };
        in
        {
          nixOnDroidConfigurations =
            let
              platform = "droid";
            in
            platform
            |> lib.custom.getHosts
            |> builtins.mapAttrs (
              hostName:
              { system }:
              let
                hostPath = ./hosts/${platform}/${system}/${hostName};
              in
              inputs.nix-on-droid.lib.nixOnDroidConfiguration rec {
                home-manager-path = inputs.home-manager.outPath;
                extraSpecialArgs = common.specialArgs hostName globals.${platform}.${system}.${hostName};

                pkgs = import nixpkgs { inherit system; };

                modules = [
                  hostPath
                  ./modules/droid
                  {
                    home-manager = common.homeManager // {
                      inherit extraSpecialArgs;
                      config = "${hostPath}/homes/nix-on-droid.nix";
                    };
                  }
                ];
              }
            );

          nixosConfigurations =
            let
              platform = "nixos";
            in
            platform
            |> lib.custom.getHosts
            |> builtins.mapAttrs (
              hostName:
              { system }:
              let
                hostPath = ./hosts/${platform}/${system}/${hostName};
              in
              lib.nixosSystem rec {
                inherit system;
                specialArgs = common.specialArgs hostName globals.${platform}.${system}.${hostName};

                modules =
                  (with inputs; [
                    disko.nixosModules.disko
                    home-manager.nixosModules.home-manager
                    nix-topology.nixosModules.default
                    nixos-facter-modules.nixosModules.facter
                    nixos-wsl.nixosModules.default
                    sops-nix.nixosModules.sops
                    nur.modules.nixos.default
                  ])
                  ++ (lib.custom.getUsers hostPath)
                  ++ (lib.custom.getHomes hostPath)
                  ++ [
                    hostPath
                    ./modules/nixos
                    {
                      networking = { inherit hostName; };

                      users.mutableUsers = false;

                      # Disables superfluous pre-installed pkgs
                      environment.defaultPackages = [ ];

                      home-manager = common.homeManager // {
                        extraSpecialArgs = specialArgs;
                      };
                    }
                  ];
              }
            );
        };

      nixvim = {
        packages.enable = true;
        # TODO: Enable once certain plugins can be disabled when checking
        # checks.enable = true;
      };

      perSystem =
        {
          self',
          lib,
          pkgs,
          system,
          ...
        }:
        {
          nixvimConfigurations.neovim = inputs.nixvim.lib.evalNixvim {
            inherit system;
            extraSpecialArgs = { inherit inputs; };
            modules = [ ./nixvim-config ];
          };

          packages = lib.packagesFromDirectoryRecursive {
            inherit (pkgs) callPackage;
            directory = ./pkgs;
          };

          # Nixvim configurations are considered
          # packages too. Let nixvim handle the checks.
          checks = { inherit (self'.packages) dumb; };

          topology.modules = [ ./topology.nix ];

          treefmt = ./treefmt.nix;

          devShells.default = pkgs.mkShell {
            name = "nixos-config";

            packages = with pkgs; [
              act

              just
              just-lsp

              nixd
              nix-melt
            ];
          };
        };
    };
}
