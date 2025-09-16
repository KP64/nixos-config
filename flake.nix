{
  description = ''
    KP64's wannabe All-In-One Nix Flake

    This flake aims to include all machines,
    be it NixOS or not (i.e. Home-Manager).

    This should range from "simple" dotfile managment
    all the way to managing multiple services for a
    fault-tolerant homelab.

    Is it a good Flake?
    Absolutely not, but I'm not a jugde.
    You are... yes YOU!
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

    # Declarative Disk partitioning
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Make the outputs compatible with non flake systems
    # The compatibility layer is comprised of the `default.nix`
    # and the `shell.nix` file in the current working directory.
    flake-compat.url = "github:edolstra/flake-compat";

    # Just for the deduplication of inputs
    # NOTE: Guys. Please AVOID using these in your projects!
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    # Bind everything together
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Manage your dotfiles, i.e. your home.
    # Intuitive name right? xD
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Import all needed nix files ;)
    import-tree.url = "github:vic/import-tree";

    # Weekly updated nix pkgs database
    # Useful for https://github.com/nix-community/comma
    # and replacing command-not-found
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Stuff that shouldn't be visible to the naked eye,
    # but doesn't have to be or can't be encrypted.
    nix-invisible = {
      url = "git+ssh://git@github.com/KP64/nix-invisible";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Better hardware-configuration replacement
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

    # AUR Nix edition
    nur = {
      url = "github:nix-community/nur";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  /*
    The outputs are akin to "results" that this flake produces.
    This ranges from a simple Network Topology all the way to
    full blown NixOS Configs.
  */
  outputs =
    inputs@{ flake-parts, nixpkgs, ... }:
    let
      customLib = import ./lib { inherit (nixpkgs) lib; };
    in
    flake-parts.lib.mkFlake
      {
        inherit inputs;
        specialArgs = { inherit customLib; };
      }
      {
        # This allows further inspection of
        # outputs via the `nix repl`
        debug = true;

        # Every system this flake supports,
        # for which perSystem will run
        # `flakeExposed` returns ALL systems
        # supported by Nix
        systems = nixpkgs.lib.systems.flakeExposed;

        /*
          Partitions define "sub flakes", whose inputs
          and results will not be shown in a consumers' flake.
          This is useful to compartmentalize flakes into more
          specialised units.
          An example would be a development flake that handles
          everything about further developing this flake like formatters etc.
        */
        partitions.dev = {
          # This will use "./dev/flake.nix"
          extraInputsFlake = ./dev;
          # While this will use "./dev/default.nix"
          module.imports = [ ./dev ];
        };
        # Moving dev related stuff to the appropriate partition
        partitionedAttrs = {
          checks = "dev";
          devShells = "dev";
          formatter = "dev";
        };

        imports = [
          (inputs.import-tree ./modules)
        ]
        ++ (with flake-parts.flakeModules; [
          modules
          partitions
        ]);
      };
}
