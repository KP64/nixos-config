{ inputs }:
# TODO: Generate Documentation
let
  inherit (inputs.nixpkgs) lib;
in
{
  ai = import ./ai.nix { inherit lib; };

  anki = import ./anki.nix { inherit lib; };

  fs = import ./fs.nix { inherit lib; };

  firefox = import ./firefox.nix { inherit lib; };

  minecraft = import ./minecraft.nix;

  nginx = import ./nginx.nix { inherit lib; };

  packages = import ./packages.nix { inherit lib; };

  util = import ./util.nix {
    inherit lib;
    inherit (inputs) self;
  };
}
