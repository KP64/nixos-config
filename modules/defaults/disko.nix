{ inputs, ... }: {
  flake-file.inputs.disko = {
    type = "github";
    owner = "nix-community";
    repo = "disko";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [ inputs.disko.flakeModules.default ];
  den.default.nixos.imports = [ inputs.disko.nixosModules.default ];
}
