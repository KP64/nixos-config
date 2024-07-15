{
  description = "My NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable-nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-systems.url = "github:nix-systems/default";

    # If something goes south. Consider this a possible problem
    # This exists i guess
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
        flake-utils.follows = "flake-utils";
      };
    };

    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
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

    treefmt = {
      url = "github:numtide/treefmt";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };

    catppuccin.url = "github:catppuccin/nix";

    obs-catppuccin = {
      url = "github:catppuccin/obs";
      flake = false;
    };

    heroic-catppuccin = {
      url = "github:catppuccin/heroic";
      flake = false;
    };

    aseprite-catppuccin = {
      url = "github:catppuccin/aseprite";
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
        flake-compat.follows = "flake-compat";
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
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };

    hyprutils = {
      url = "github:hyprwm/hyprutils";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "nix-systems";
      };
    };

    hyprlang = {
      url = "github:hyprwm/hyprlang";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "nix-systems";
        hyprutils.follows = "hyprutils";
      };
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "nix-systems";
        hyprlang.follows = "hyprlang";
        hyprutils.follows = "hyprutils";
        xdph.follows = "xdph";
      };
    };

    xdph = {
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
        hyprutils.follows = "hyprutils";
      };
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      customLib = import ./lib.nix { inherit nixpkgs inputs; };
    in
    {
      nixosConfigurations = {
        kg = customLib.mkSystem {
          username = "kg";
          system = "x86_64-linux";
        };
      };
    };
}
