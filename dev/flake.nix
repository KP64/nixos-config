{
  description = ''
    Private inputs for development purposes.
    These are used by the top level flake in the `dev` partition,
    but do not appear in consumers' lock files.
  '';

  inputs = {
    # TODO: Unpin once systems.elaborate when https://github.com/nix-community/nixvim/issues/4426 is closed
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      rev = "3e41b24abd260e8f71dbe2f5737d24122f972158";
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
