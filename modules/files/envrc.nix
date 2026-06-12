toplevel@{ self, ... }:
{
  perSystem.files.file.".envrc".text =
    let
      inherit (toplevel.config.lib.flake.util) getRelativePath;

    in
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
}
