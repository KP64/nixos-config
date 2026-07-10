{ config, self, ... }: {
  perSystem =
    {
      system,
      lib,
      pkgs,
      ...
    }:
    {
      files.file.".envrc".source =
        let
          inherit (config.lib.flake.util) getRelativePath;
          envrc =
            # bash
            ''
              #!/usr/bin/env bash

              # .envrc file is especially important for those
              # that use direnv and by extension nix-direnv.
              # It is like a hot-reloading equivalent of "nix develop"

              # Only continue if user has nix-direnv
              if has nix_direnv_version; then
                # We only really care about hot-reloading the devShell and the flake itself
                watch_file ${getRelativePath "${self}/dev/"}*
                use flake . --accept-flake-config
              fi
            '';
        in
        pkgs.runCommand "formatted-envrc" { } ''
          cat > .envrc <<'EOF'
          ${envrc}
          EOF

          ${lib.getExe config.flake.formatter.${system}} --no-cache --tree-root-file .envrc

          cat .envrc > "$out"
        '';
    };
}
