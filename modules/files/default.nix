{ inputs, ... }: {
  flake-file.inputs.files = {
    type = "github";
    owner = "mightyiam";
    repo = "files";
    inputs = {
      flake-parts.follows = "flake-parts";
      import-tree.follows = "import-tree";
      nixpkgs.follows = "nixpkgs";
    };
  };

  imports = [ "${inputs.files}/flake-module.nix" ];

  perSystem.files.writer.app = true;
}
