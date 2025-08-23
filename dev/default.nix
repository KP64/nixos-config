{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem =
    { self', pkgs, ... }:
    {
      checks = self'.packages;

      treefmt = ./treefmt.nix;

      devShells.default = pkgs.mkShell {
        name = "config";

        packages = with pkgs; [
          just
          nil
          nix-melt
        ];
      };
    };
}
