{
  description = "KP64's Ultimate Nixos ❄️";

  inputs = {
    catppuccin.url = "github:catppuccin/nix";

    catppuccin-aseprite = {
      url = "github:catppuccin/aseprite";
      flake = false;
    };

    catppuccin-blender = {
      url = "github:Dalibor-P/blender";
      flake = false;
    };

    catppuccin-heroic = {
      url = "github:catppuccin/heroic";
      flake = false;
    };

    catppuccin-imhex = {
      url = "github:catppuccin/imhex";
      flake = false;
    };

    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";

    flake-parts.url = "github:hercules-ci/flake-parts";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprgrass = {
      url = "github:horriblename/hyprgrass";
      inputs.hyprland.follows = "hyprland";
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    hyprpolkitagent = {
      url = "github:hyprwm/hyprpolkitagent";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    hyprsunset = {
      url = "github:hyprwm/hyprsunset";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    # TODO: Re-add ASAP
    impermanence.url = "github:nix-community/impermanence";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    navi-denis-cheats = {
      url = "github:denisidoro/cheats";
      flake = false;
    };

    navi-denis-dotfiles = {
      url = "github:denisidoro/dotfiles";
      flake = false;
    };

    navi-denis-tldr-pages = {
      url = "github:denisidoro/navi-tldr-pages";
      flake = false;
    };

    navi-papanito-cheats = {
      url = "github:papanito/cheats";
      flake = false;
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs = {
        flake-compat.follows = "flake-compat";
        nix-index-database.follows = "nix-index-database";
        nixpkgs.follows = "nixpkgs";
      };
    };

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
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    nix-topology = {
      url = "github:oddlama/nix-topology";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
      };
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nvf = {
      url = "github:notashelf/nvf";
      inputs = {
        flake-parts.follows = "flake-parts";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    nur = {
      url = "github:nix-community/nur";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    # TODO: Find better alternatives
    potato-fox = {
      url = "git+https://codeberg.org/awwpotato/PotatoFox.git";
      flake = false;
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    starship = {
      url = "github:starship/starship";
      flake = false;
    };

    systems.url = "github:nix-systems/default";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yazi-hexyl = {
      url = "github:Reledia/hexyl.yazi";
      flake = false;
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = with inputs; [
        treefmt-nix.flakeModule
        nix-topology.flakeModule
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
            overlays = [ inputs.hyprpanel.overlay ];

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
                hostPath = ./hosts/droid/${system}/${hostName};
              in
              inputs.nix-on-droid.lib.nixOnDroidConfiguration rec {
                home-manager-path = inputs.home-manager.outPath;
                extraSpecialArgs = common.specialArgs hostName globals.${platform}.${system}.${hostName};

                pkgs = import nixpkgs {
                  inherit system;
                  overlays = common.overlays ++ [ inputs.nix-on-droid.overlays.default ];
                };

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
                hostPath = ./hosts/nixos/${system}/${hostName};
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
                      nixpkgs = { inherit (common) overlays; };

                      networking = { inherit hostName; };

                      users.mutableUsers = false;

                      home-manager = common.homeManager // {
                        extraSpecialArgs = specialArgs;
                      };
                    }
                  ];
              }
            );
        };

      perSystem =
        {
          self',
          pkgs,
          system,
          ...
        }:
        {
          _module.args.pkgs = import nixpkgs {
            inherit system;
            overlays = [ inputs.neovim-nightly-overlay.overlays.default ];
          };

          packages =
            (nixpkgs.lib.packagesFromDirectoryRecursive {
              inherit (pkgs) callPackage;
              directory = ./pkgs;
            })
            // rec {
              default = neovim;
              inherit
                (inputs.nvf.lib.neovimConfiguration {
                  inherit pkgs;
                  modules = [ ./neovim.nix ];
                })
                neovim
                ;
            };

          # Check all packages
          checks = self'.packages;

          topology.modules = [ ./topology ];

          treefmt = ./treefmt.nix;

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              act
              just
              nixd
              nix-melt
            ];
          };
        };
    };
}
