{
  description = "My NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };

    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-systems.url = "github:nix-systems/default";

    flake-compat.url = "github:edolstra/flake-compat";

    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "nix-systems";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };

    nix-topology = {
      url = "github:oddlama/nix-topology";
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
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        nix-index-database.follows = "nix-index-database";
      };
    };

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
      };
    };

    catppuccin.url = "github:catppuccin/nix";

    heroic-catppuccin = {
      url = "github:catppuccin/heroic";
      flake = false;
    };

    aseprite-catppuccin = {
      url = "github:catppuccin/aseprite";
      flake = false;
    };

    imhex-catppuccin = {
      url = "github:catppuccin/imhex";
      flake = false;
    };

    blender-catppuccin = {
      url = "github:Dalibor-P/blender";
      flake = false;
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
      };
    };

    nur.url = "github:nix-community/nur";

    potato-fox = {
      url = "git+https://codeberg.org/awwpotato/PotatoFox.git";
      flake = false;
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };

    nixcord.url = "github:kaylorben/nixcord";

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "nix-systems";
      };
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "nix-systems";
      };
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    navi-papanito-cheats = {
      url = "github:papanito/cheats";
      flake = false;
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

    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      customLib = import ./lib.nix { inherit nixpkgs inputs; };
    in
    {
      nixosConfigurations = {
        kg = customLib.mkSystem {
          username = "kg";
          system = "x86_64-linux";
        };

        ws = customLib.mkSystem {
          username = "ws";
          system = "x86_64-linux";
          wsl = true;
        };

        rs = customLib.mkSystem {
          username = "rs";
          system = "aarch64-linux";
          pi = true;
        };
      };
    }
    // inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ inputs.nix-topology.overlays.default ];
        };
      in
      {
        # TODO: Fill out Topology
        topology = import inputs.nix-topology {
          inherit pkgs;
          modules = [ { inherit (self) nixosConfigurations; } ];
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            deadnix
            just
            nil
            nix-health
            nix-melt
            nixfmt-rfc-style
            nurl
            statix
          ];
        };
      }
    );
}
