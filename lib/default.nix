{ lib }:
rec {
  fs = import ./fs.nix { inherit lib; };

  util = import ./util.nix { inherit lib; };

  firefox = import ./firefox.nix { inherit lib util; };
}
