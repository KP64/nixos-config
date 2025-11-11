{ inputs }:
# TODO: Generate Documentation
let
  inherit (inputs.nixpkgs) lib;

  util = import ./util.nix {
    inherit lib;
    inherit (inputs) self;
  };
in
{
  ai = import ./ai.nix { inherit lib; };

  anki = import ./anki.nix { inherit lib; };

  fs = import ./fs.nix { inherit lib; };

  firefox = import ./firefox.nix { inherit lib util; };

  minecraft = import ./minecraft.nix;

  inherit util;
}
