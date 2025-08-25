{ inputs }:
rec {
  # Every firefox related functions
  firefox = import ./firefox.nix { inherit inputs util; };

  # Functions to ease the importing experience
  fs = import ./fs.nix { inherit inputs; };

  # Utils that are necessary for the custom library
  util = import ./util.nix { inherit inputs; };
}
