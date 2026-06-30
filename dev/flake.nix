{
  description = ''
    Private inputs for development purposes.
    These are used by the top level flake in the `dev` partition,
    but do not appear in consumers' lock files.
  '';

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
    };
    treefmt-nix = {
      type = "github";
      owner = "numtide";
      repo = "treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # TODO: Remove once nufmt is back in treefmt-nix
    nufmt = {
      type = "github";
      owner = "nushell";
      repo = "nufmt";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
  };

  # This flake is only used for its inputs.
  outputs = _: { };
}
