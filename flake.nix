{
  description = "My NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-systems.url = "github:nix-systems/default";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "nix-systems";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-ld-rs = {
      url = "github:nix-community/nix-ld-rs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        nix-index-database.follows = "nix-index-database";
      };
    };

    # TODO: Move on from catppuccin as it is a pain.
    catppuccin.url = "github:catppuccin/nix";

    obs-catppuccin = {
      url = "github:catppuccin/obs";
      flake = false;
    };

    heroic-catppuccin = {
      url = "github:catppuccin/heroic";
      flake = false;
    };

    hyprland-catppuccin = {
      url = "github:catppuccin/hyprland";
      flake = false;
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    nur.url = "github:nix-community/nur";

    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    eww = {
      url = "github:elkowar/eww";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprlang = {
      url = "github:hyprwm/hyprlang";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "nix-systems";
      };
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "nix-systems";
        hyprlang.follows = "hyprlang";
        xdph.follows = "xdg-desktop-portal-hyprland";
      };
    };

    xdg-desktop-portal-hyprland = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "nix-systems";
        hyprlang.follows = "hyprlang";
      };
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "nix-systems";
        hyprlang.follows = "hyprlang";
      };
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "nix-systems";
        hyprlang.follows = "hyprlang";
      };
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "nix-systems";
        hyprlang.follows = "hyprlang";
      };
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    {
      nixosConfigurations.kg = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/kg/configuration.nix
          { nixpkgs.overlays = [ inputs.nur.overlay ]; }

          inputs.catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.default
          {
            home-manager = {
              extraSpecialArgs = {
                inherit inputs;
              };
              useGlobalPkgs = true;
              useUserPackages = true;
              # TODO: Username changing is tedious. Make it one global variable 
              users.kg = {
                imports = [
                  ./hosts/kg/home.nix
                  inputs.nix-index-database.hmModules.nix-index
                  inputs.catppuccin.homeManagerModules.catppuccin
                ];
              };
            };
          }
        ];
      };
    };
}
