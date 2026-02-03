{
  description = ''
    KP64's Wannabe All-In-One Nix Flake

    This flake aims to include everything.
    Ranging from "simple" dotfile management with Home Manager
    all the way to managing multiple services
    for a fault-tolerant homelab.

    Is it a good Flake?
    Absolutely not, but I'm not a jugde.
    You are... yes, YOU!
    Roast this Flake (and by extension me) however you like!
  '';

  /*
    Think of inputs like dependencies that
    are used throughout the project

    The "url" specifies, Where this dependency lives.
    It could be a Repository, a file or a path, it doesn't matter.
    Your imagination is the limit.

    `inputs.<name>.follows` means sharing an input `<name>`.
    The most common example is `inputs.nixpkgs.follows = "nixpkgs"`
    This indicates that the input that in turn has a dependency on
    nixpkgs shouldn't bring its own copy of it, but reuse the one
    already specified in this very flake.

    If you are hellbent on keeping your lockfile as small as Possible
    you can "delete" inputs too, by using `inputs.<name>.follows = "";`.
    NOTE: IIRC this should only be done for inputs that are only for dev
          purposes and do not affect the consuming/usage of said flake.
          An example would be `treefmt-nix`.
  */
  inputs = {
    /*
      There are multiple branches of nixpkgs.
      The most important distinction is between
      `nixos` and `nixpkgs` imho.
      Without going into details, think of the branches
      starting with `nixos` as intended to be used in flakes
      that configure your system, while branches starting with
      `nixpkgs` are used for flakes that only package programs.

      Compare this flake (which uses the nixos-unstable branch),
      with the dotz flake (github repo: https://github.com/KP64/dotz)

      FYI. Don't shy away from using the unstable branches.
      In the worst case NixOS rollbacks come in clutch!
      Unstable it is Baby 🥳

      NOTE: It is USUALLY alright to follow a "nixpkgs" input
            even if the branch is different
    */
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Firefox Hardening
    better-fox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };

    # Everything Catppuccin 😺
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    /*
      Just for the deduplication of inputs
      NOTE: Guys. Please AVOID using these in your projects!
            If you need something similar just use flake-parts (https://github.com/hercules-ci/flake-parts).
            But most of the time you will not need ANY of them.
    */
    dedup_systems.url = "github:nix-systems/default";
    dedup_flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "dedup_systems";
    };

    # Declarative Disk partitioning
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix DSL for DNS-Zones
    dns = {
      url = "github:kirelagin/dns.nix";
      inputs = {
        flake-utils.follows = "dedup_flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # My custom made "colorscript"
    dotz = {
      url = "github:KP64/dotz";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Bind everything together
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Nix binary cache
    harmonia = {
      url = "github:nix-community/harmonia";
      # NOTE: Do not "delete" treefmt-nix or Harmonia won't build >:(
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Manage your dotfiles, i.e. your home.
    # Intuitive name right? xD
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Import all needed nix files ;)
    import-tree.url = "github:vic/import-tree";

    # Realtime audio
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Latest neovim version
    # Do not override inputs. Cache is provided.
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    # Niri WM
    niri-flake.url = "github:sodiboo/niri-flake";

    /*
      Nix managed Neovim
      NOTE: They use the latest possible nixpkgs branch.
            Again. nixpkgs and nixos branches are not the same.
            Overriding nixpkgs can cause breakage, even though rarely.
    */
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        flake-parts.follows = "flake-parts";
        systems.follows = "dedup_systems";
      };
    };

    # This provides package wrapping functions, that are
    # especially important for home-manager setups on non
    # NixOS systems when trying to get graphical applications working.
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs = {
        flake-utils.follows = "dedup_flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Weekly updated nixpkgs database
    # Useful for Comma (https://github.com/nix-community/comma)
    # and replacing command-not-found
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Stuff that shouldn't be visible to the naked eye,
    # but doesn't have to be or can't be encrypted.
    # NOTE: Shallow Cloning because .git directory could leak.
    nix-invisible = {
      url = "git+ssh://git@github.com/KP64/nix-invisible?shallow=1";
      inputs = {
        flake-parts.follows = "flake-parts";
        import-tree.follows = "import-tree";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Custom Library functions framework
    nix-lib = {
      url = "github:Dauliac/nix-lib";
      inputs = {
        flake-parts.follows = "flake-parts";
        import-tree.follows = "import-tree";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "dedup_systems";
      };
    };

    # Nix managed Minecraft Servers.
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs = {
        flake-compat.follows = "";
        flake-utils.follows = "dedup_flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Network Topology based on the nixosConfigurations
    nix-topology = {
      url = "github:oddlama/nix-topology";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # NixOS on the raspberry Pi 🥧
    # Do not override inputs. It has a binary cache.
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi";

    # Quickshell preconfiguration for niri
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # AUR Nix edition
    nur = {
      url = "github:nix-community/nur";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Utility to call all custom packages of this flake
    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Idle manager
    stasis = {
      url = "github:saltnpepper97/stasis";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  /*
    The outputs are akin to "results" that this flake produces.
    This ranges from a simple Network Topology all the way to
    full blown NixOS Configs.
  */
  outputs =
    inputs: inputs.import-tree ./modules |> inputs.flake-parts.lib.mkFlake { inherit inputs; };
}
