{ lib }:
# TODO: Generate Documentation
# TODO: Update Library Examples
rec {
  ai = import ./ai.nix { inherit lib; };

  anki = import ./anki.nix { inherit lib; };

  fs = import ./fs.nix { inherit lib; };

  firefox = import ./firefox.nix { inherit lib util; };

  minecraft = import ./minecraft.nix;

  util = import ./util.nix { inherit lib; };
}
