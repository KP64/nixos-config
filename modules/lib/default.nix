{ den, inputs, ... }: {
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

  nix-lib.enable = true;

  den = {
    default.includes = [ den.aspects.customLib ];

    aspects.customLib = {
      nixos = {
        imports = [ inputs.nix-lib.nixosModules.default ];
        nix-lib.enable = true;
      };

      homeManager = {
        imports = [ inputs.nix-lib.homeModules.default ];
        nix-lib.enable = true;
      };
    };
  };
}
