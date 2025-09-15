{ lib }:
rec {
  util = import ./util.nix { inherit lib; };

  firefox = import ./firefox.nix { inherit lib util; };
}
