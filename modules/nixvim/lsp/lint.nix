{ moduleWithSystem, ... }:
{
  flake.modules.nixvim.lint = moduleWithSystem (
    { inputs', ... }:
    {
      plugins.lint = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
        # Do not add linters that are easily breakable by their version.
        # These packages "overwrite" whatever is installed by devShells.
        # E.g.:
        # Let's say Clippy 1.88.0 is installed by nixpkgs but the rust
        # project uses lints from 1.89.0, then Clippy will error out.
        autoInstall = {
          enable = true;
          overrides = {
            statix = inputs'.statix.packages.default;
            clippy = null;
          };
        };
        lintersByFt = {
          bash = [ "shellcheck" ];
          sh = [ "shellcheck" ];
          docker = [ "hadolint" ];
          rust = [ "clippy" ];
          nix = [
            "deadnix"
            "statix"
          ];
          python = [ "ruff" ];
          markdown = [ "markdownlint" ];
        };
      };
    }
  );
}
