{ inputs }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  anki = import ./anki.nix { inherit lib; };

  fs = import ./fs.nix { inherit lib; };

  firefox = import ./firefox.nix { inherit lib; };

  packages = import ./packages.nix { inherit lib; };

  util = import ./util.nix {
    inherit lib;
    inherit (inputs) self;
  };
}
