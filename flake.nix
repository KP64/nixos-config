{
  description = "KP64's All-In-One Nix Flake";

  # Think of inputs like dependencies that
  # are used throughout the project
  #
  # The "url" specifies, Where this dependency lives.
  # It could be a GitHub, GitLab, etc. Repo, a file, a path doesn't matter.
  # Bend it to your own will.
  #
  # inputs.<name>.follows is like sharing an input.
  # The most common example is `inputs.nixpkgs.follows = "nixpkgs"`
  # This indicates that the input that in turn has a dependency on
  # nixpkgs shouldn't bring its own copy of it, but reuse the one
  # already specified inputs in this very flake.
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Everything Catppuccin 😺
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    # Make the outputs compatible with non flake systems
    # The compatibility layer is comprised of the default.nix
    # and the shell.nix file in the current working directory
    flake-compat.url = "github:edolstra/flake-compat";

    # Just for deduplication of inputs
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    # Bind everything together
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Manage Dotfiles
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Ephemeral root storage
    # Clean up files on every reboot :P
    impermanence.url = "github:nix-community/impermanence";

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
    # TODO: Unfix the version, when Systemd issue is resolved
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules/354ed498c9628f32383c3bf5b6668a17cdd72a28";

    # Nixos on the Raspberry Pi
    nixos-raspberrypi = {
      url = "github:nvmd/nixos-raspberrypi/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem, ... }:
      {
        debug = true;

        systems = inputs.nixpkgs.lib.systems.flakeExposed;

        imports =
          (with inputs.flake-parts.flakeModules; [
            flakeModules
            partitions
          ])
          ++ (with inputs; [
            home-manager.flakeModules.home-manager
            nix-topology.flakeModule
          ]);

        partitions.dev = {
          extraInputsFlake = ./dev;
          module.imports = [ ./dev ];
        };

        partitionedAttrs = {
          checks = "dev";
          devShells = "dev";
          formatter = "dev";
        };

        flake =
          let
            lib = inputs.nixpkgs.lib.extend (_: _: { custom = import ./lib { inherit inputs; }; });
          in
          {
            flakeModules.default = { };

            nixosConfigurations =
              let
                mkNixOSSystem =
                  host:
                  let
                    hardware-conf = lib.importJSON ./hosts/nixos/${host}/facter.json;
                  in
                  withSystem hardware-conf.system (
                    { inputs', ... }:
                    lib.nixosSystem {
                      specialArgs = { inherit inputs inputs'; };
                      modules = [
                        ./hosts/nixos/${host}
                        {
                          home-manager.extraSpecialArgs = { inherit inputs inputs'; };
                          nixpkgs.config.allowAliases = false;
                        }
                      ];
                    }
                  );
              in
              ./hosts/nixos |> builtins.readDir |> builtins.mapAttrs (host: _: mkNixOSSystem host);
          };
      }
    );
}
