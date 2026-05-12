{ inputs, ... }:
{
  flake-file.inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.default = {
    nixos.imports = [ inputs.sops-nix.nixosModules.default ];
    homeManager.imports = [ inputs.sops-nix.homeModules.default ];
  };
}
