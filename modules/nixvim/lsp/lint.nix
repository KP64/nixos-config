{
  flake.modules.nixvim.lsp =
    { lib, pkgs, ... }:
    {
      plugins.lint = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
        # Do not add linters that are easily breakable by their version.
        # These packages "overwrite" whatever is installed devShells.
        # E.g.:
        # Let's say Clippy 1.88.0 is installed by nixpkgs but the rust
        # project uses lints from 1.89.0, then Clippy will error out.
        linters = builtins.mapAttrs (_: v: { cmd = lib.getExe v; }) {
          markdownlint = pkgs.markdownlint-cli;
          inherit (pkgs)
            deadnix
            statix
            shellcheck
            ruff
            hadolint
            ;
        };
        lintersByFt = rec {
          bash = [ "shellcheck" ];
          sh = bash;
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
    };
}
