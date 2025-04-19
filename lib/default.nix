{ inputs, rootPath }:
let
  systems = import ./systems.nix { inherit inputs rootPath; };
  utils = import ./utils.nix { inherit inputs; };
in
systems // utils
