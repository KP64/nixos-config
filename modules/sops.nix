{ inputs, ... }:
{
  flake-file.inputs.sops-nix = {
    type = "github";
    owner = "Mic92";
    repo = "sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.default = {
    nixos.imports = [ inputs.sops-nix.nixosModules.default ];
    homeManager.imports = [ inputs.sops-nix.homeModules.default ];
  };
}
