{ inputs, self, ... }:
{
  flake-file.inputs.pkgs-by-name-for-flake-parts = {
    type = "github";
    owner = "drupol";
    repo = "pkgs-by-name-for-flake-parts";
  };

  imports = [ inputs.pkgs-by-name-for-flake-parts.flakeModule ];

  perSystem.pkgsDirectory = "${self}/pkgs";
}
