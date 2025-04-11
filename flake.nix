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
      flake = false;
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

    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";

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

    systems.url = "github:nix-systems/default";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = with inputs; [
        treefmt-nix.flakeModule
        nix-topology.flakeModule
        home-manager.flakeModules.home-manager
        pkgs-by-name-for-flake-parts.flakeModule
      ];

      flake =
        let
          inherit (inputs.nixpkgs) lib;
          rootPath = inputs.self.outPath;
          # TODO: Extend nixos lib with it
          customLib = import ./lib { inherit inputs rootPath; };
          # TODO: Important to do on a per User basis!
          invisible = import "${inputs.nix-invisible}/globals.nix";
        in
        {
          nixOnDroidConfigurations =
            "droid"
            |> customLib.getHosts
            |> builtins.mapAttrs (
              hostName:
              { system }:
              let
                hostPath = ./hosts/droid/${system}/${hostName};
              in
              inputs.nix-on-droid.lib.nixOnDroidConfiguration rec {
                home-manager-path = inputs.home-manager.outPath;
                extraSpecialArgs = {
                  inherit
                    inputs
                    hostName
                    rootPath
                    customLib
                    invisible
                    ;
                };

                pkgs = import inputs.nixpkgs {
                  inherit system;
                  overlays = with inputs; [
                    nix-on-droid.overlays.default
                    hyprpanel.overlay
                  ];
                };

                modules = [
                  hostPath
                  ./modules/droid
                  {
                    home-manager = {
                      useGlobalPkgs = true;
                      useUserPackages = true;
                      backupFileExtension = "hm-bak";
                      inherit extraSpecialArgs;
                      sharedModules = [ ./modules/home ];
                      # TODO: Refactor to support different username
                      config = "${hostPath}/homes/nix-on-droid.nix";
                    };
                  }
                ];
              }
            );

          nixosConfigurations =
            "nixos"
            |> customLib.getHosts
            |> builtins.mapAttrs (
              hostName:
              { system }:
              let
                hostPath = ./hosts/nixos/${system}/${hostName};
              in
              lib.nixosSystem rec {
                # TODO: Seems like system specification not needed.
                # Maybe it only woks because facter takes care of it.
                # If it isn't neede at all this would simplify the directory
                # logic by a lot.
                inherit system;
                specialArgs = {
                  inherit
                    inputs
                    hostName
                    rootPath
                    customLib
                    invisible
                    ;
                };
                modules =
                  (with inputs; [
                    disko.nixosModules.disko
                    home-manager.nixosModules.home-manager
                    nix-topology.nixosModules.default
                    nixos-facter-modules.nixosModules.facter
                    nixos-wsl.nixosModules.default
                    catppuccin.nixosModules.catppuccin
                    sops-nix.nixosModules.sops
                  ])
                  ++ (customLib.getUsers hostPath)
                  ++ (customLib.getHomes hostPath)
                  ++ [
                    hostPath
                    ./modules/nixos
                    {
                      nixpkgs.overlays = with inputs; [
                        nur.overlays.default
                        hyprpanel.overlay
                      ];

                      networking = { inherit hostName; };

                      users.mutableUsers = false;

                      catppuccin.cache.enable = true;

                      home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        backupFileExtension = "backup";
                        extraSpecialArgs = specialArgs;

                        sharedModules = [ ./modules/home ];
                      };
                    }
                  ];
              }
            );
        };

      perSystem =
        { self', pkgs, ... }:
        {
          pkgsDirectory = ./pkgs;

          packages = rec {
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
