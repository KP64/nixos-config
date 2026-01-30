{ inputs }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  anki = import ./anki.nix { inherit lib; };

  firefox = import ./firefox.nix { inherit lib; };

  packages = import ./packages.nix { inherit lib; };
}
