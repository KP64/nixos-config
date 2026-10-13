{ inputs, ... }:
let
  nix-lib.enable = true;
in
{
  flake-file.inputs.nix-lib = {
    type = "github";
    owner = "Dauliac";
    repo = "nix-lib";
    inputs = {
      flake-parts.follows = "flake-parts";
      nixpkgs-lib.follows = "nixpkgs";
    };
  };

  imports = [ inputs.nix-lib.flakeModules.default ];

  inherit nix-lib;

  den.default = {
    nixos = {
      imports = [ inputs.nix-lib.nixosModules.default ];
      inherit nix-lib;
    };

    homeManager = {
      imports = [ inputs.nix-lib.homeModules.default ];
      inherit nix-lib;
    };
  };
}
