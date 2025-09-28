{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        name = "config";
        packages = with pkgs; [
          just
          just-lsp

          nil
        ];
      };
    };
}
