{ den, inputs, ... }: {
  flake-file.inputs.nix-lib = {
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
