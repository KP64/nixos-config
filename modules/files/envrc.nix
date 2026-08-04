{ config, self, ... }: {
  perSystem =
    {
      system,
      lib,
      pkgs,
      ...
    }:
    let
      file = ".envrc";
    in
    {
      files.file.${file}.source =
        let
          inherit (config.lib.flake.util) getRelativePath;
          content =
            # bash
            ''
              #!/usr/bin/env bash

              # ${file} file is especially important for those
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
        pkgs.runCommand "formatted-${file}" { } ''
          cat > ${file} <<'EOF'
          ${content}
          EOF

          ${lib.getExe config.flake.formatter.${system}} --no-cache --tree-root-file ${file}

          cat ${file} > "$out"
        '';
    };
}
