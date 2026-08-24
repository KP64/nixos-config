# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  description = "KP64's Overengineered Nix Flake";

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  nixConfig = {
    accept-flake-config = true;
    auto-optimise-store = true;
    experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operators"
    ];
    extra-substituters = [ "https://catppuccin.cachix.org" ];
    extra-trusted-public-keys = [
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
    ];
    fsync-store-paths = true;
    lint-absolute-path-literals = "warn";
    lint-short-path-literals = "fatal";
    lint-url-literals = "fatal";
    preallocate-contents = true;
    substituters = [
      "https://cache.nixos-cuda.org"
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://nixos-raspberrypi.cachix.org"
    ];
    sync-before-registering = true;
    trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
    use-xdg-base-directories = true;
  };

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
    files = {
      type = "github";
      owner = "mightyiam";
      repo = "files";
      inputs = {
        flake-parts.follows = "flake-parts";
        import-tree.follows = "import-tree";
        make-shell.inputs.flake-compat.follows = "";
        nixpkgs.follows = "nixpkgs";
      };
    };
    flake-file = {
      type = "github";
      owner = "denful";
      repo = "flake-file";
    };
    flake-parts = {
      type = "github";
      owner = "hercules-ci";
      repo = "flake-parts";
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
    import-tree = {
      type = "github";
      owner = "denful";
      repo = "import-tree";
    };
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
    nix-index-database = {
      type = "github";
      owner = "nix-community";
      repo = "nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-invisible = {
      type = "git";
      url = "ssh://git@github.com/KP64/nix-invisible";
      shallow = true;
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
        flake-parts.follows = "flake-parts";
        nixpkgs-lib.follows = "nixpkgs";
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
      ref = "pull/162/head";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixos-raspberrypi = {
      type = "github";
      owner = "nvmd";
      repo = "nixos-raspberrypi";
      inputs = {
        flake-compat.follows = "";
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixos-raspberrypi-no-console = {
      type = "github";
      owner = "KP64";
      repo = "nixos-raspberrypi";
      inputs = {
        argononed.follows = "nixos-raspberrypi/argononed";
        flake-compat.follows = "nixos-raspberrypi/flake-compat";
        nixos-images.follows = "nixos-raspberrypi/nixos-images";
        nixpkgs.follows = "nixos-raspberrypi/nixpkgs";
      };
    };
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };
    nixvim = {
      type = "github";
      owner = "nix-community";
      repo = "nixvim";
      inputs.flake-parts.follows = "flake-parts";
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
