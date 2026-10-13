{ inputs, ... }: {
  # NOTE: Shallow Cloning because .git directory could leak.
  flake-file.inputs.nix-invisible = {
    type = "git";
    url = "ssh://git@github.com/KP64/nix-invisible";
    shallow = true;
    inputs = {
      den.follows = "den";
      flake-parts.follows = "flake-parts";
      import-tree.follows = "import-tree";
      nixpkgs.follows = "nixpkgs";
    };
  };

  imports = [ (inputs.den.namespace "invis" [ inputs.nix-invisible ]) ];
  den.schema = {
    user.imports = [ inputs.nix-invisible.denful.invis.schema.user ];
    # TODO: Include Homelab
    # host.imports = [ inputs.nix-invisible.denful.invis.schema.host ];
  };
}
