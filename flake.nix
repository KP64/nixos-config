# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  description = "KP64's Overengineered Nix Flake";

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    better-fox = {
      type = "github";
      owner = "yokoffing";
      repo = "Betterfox";
      flake = false;
    };
    catppuccin = {
      type = "github";
      owner = "catppuccin";
      repo = "nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    den = {
      type = "github";
      owner = "denful";
      repo = "den";
    };
    disko = {
      type = "github";
      owner = "nix-community";
      repo = "disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dns = {
      type = "github";
      owner = "kirelagin";
      repo = "dns.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-file.url = "github:denful/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    harmonia = {
      type = "github";
      owner = "nix-community";
      repo = "harmonia";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "";
      };
    };
    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";
    lanzaboote = {
      type = "github";
      owner = "nix-community";
      repo = "lanzaboote";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit.follows = "";
      };
    };
    musnix = {
      type = "github";
      owner = "musnix";
      repo = "musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      type = "github";
      owner = "nix-community";
      repo = "neovim-nightly-overlay";
    };
    niri-flake = {
      type = "github";
      owner = "sodiboo";
      repo = "niri-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
      };
    };
    nix-index-database = {
      type = "github";
      owner = "nix-community";
      repo = "nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-invisible = {
      url = "git+ssh://git@github.com/KP64/nix-invisible?shallow=1";
      inputs = {
        flake-parts.follows = "flake-parts";
        import-tree.follows = "import-tree";
        nixpkgs.follows = "nixpkgs";
      };
    };
    nix-lib = {
      type = "github";
      owner = "Dauliac";
      repo = "nix-lib";
      inputs = {
        devour-flake.follows = "";
        flake-parts.follows = "flake-parts";
        get-flake.follows = "";
        import-tree.follows = "import-tree";
        nix-unit.inputs = {
          nix-github-actions.follows = "";
          treefmt-nix.follows = "";
        };
        nixpkgs.follows = "nixpkgs";
      };
    };
    nix-minecraft = {
      type = "github";
      owner = "Infinidoge";
      repo = "nix-minecraft";
      inputs = {
        flake-compat.follows = "";
        nixpkgs.follows = "nixpkgs";
      };
    };
    nix-topology = {
      type = "github";
      owner = "oddlama";
      repo = "nix-topology";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixos-raspberrypi = {
      type = "github";
      owner = "nvmd";
      repo = "nixos-raspberrypi";
      inputs.flake-compat.follows = "";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-coder = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "pull/483203/head";
    };
    nixvim = {
      type = "github";
      owner = "nix-community";
      repo = "nixvim";
      inputs.flake-parts.follows = "flake-parts";
    };
    noctalia = {
      type = "github";
      owner = "noctalia-dev";
      repo = "noctalia-shell";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        noctalia-qs.inputs = {
          nixpkgs.follows = "nixpkgs";
          treefmt-nix.follows = "";
        };
      };
    };
    nur = {
      type = "github";
      owner = "nix-community";
      repo = "nur";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    pkgs-by-name-for-flake-parts = {
      type = "github";
      owner = "drupol";
      repo = "pkgs-by-name-for-flake-parts";
    };
    sops-nix = {
      type = "github";
      owner = "Mic92";
      repo = "sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
