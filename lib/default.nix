{ lib, self }:
rec {
  fs = import ./fs.nix { inherit lib self; };

  util = import ./util.nix { inherit lib; };

  firefox = import ./firefox.nix { inherit lib util; };
}
