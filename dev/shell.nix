{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        name = "config";
        packages = [ pkgs.nil ];
      };
    };
}
