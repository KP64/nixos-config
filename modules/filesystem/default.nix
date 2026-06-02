{ inputs, ... }: {
  flake-file.inputs.disko = {
    type = "github";
    owner = "nix-community";
    repo = "disko";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [ inputs.disko.flakeModules.default ];

  den.aspects.fs = {
    nixos.imports = [ inputs.disko.nixosModules.default ];

    _.btrfs.nixos = {
      services.btrfs.autoScrub = {
        enable = true;
        fileSystems = [ "/" ];
      };
    };
  };
}
