{ lib }:
# TODO: Generate Documentation
rec {
  fs = import ./fs.nix { inherit lib; };

  util = import ./util.nix { inherit lib; };

  firefox = import ./firefox.nix { inherit lib util; };
}
