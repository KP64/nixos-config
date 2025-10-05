{ lib }:
# TODO: Generate Documentation
rec {
  ai = import ./ai.nix { inherit lib; };

  fs = import ./fs.nix { inherit lib; };

  firefox = import ./firefox.nix { inherit lib util; };

  util = import ./util.nix { inherit lib; };
}
