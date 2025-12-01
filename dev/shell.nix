{ inputs, ... }:
{
  perSystem =
    { lib, pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        name = "config";
        packages =
          (with pkgs; [
            nil
            yaml-language-server
            vscode-json-languageserver

            nix-melt
          ])
          ++ [
            (pkgs.writers.writeNuBin "upin"
              {
                makeWrapperArgs = [
                  "--prefix"
                  "PATH"
                  ":"
                  (lib.makeBinPath (
                    with pkgs;
                    [
                      gum
                      nixVersions.latest
                    ]
                  ))
                ];
              }
              # nu
              ''
                def main [...inputs: string] {
                  let selection = if not ($inputs | is-empty) {
                    $inputs
                  } else {
                    gum choose --no-limit ${lib.concatStringsSep " " (builtins.attrNames inputs)} | lines
                  }
                  gum confirm "Update?" ; nix flake update ...$selection
                }
              ''
            )
            (pkgs.writers.writeNuBin "attach" # nu
              ''
                def main [server: string] {
                  sudo ${lib.getExe pkgs.tmux} -S /run/minecraft/($server).sock attach
                }
              ''
            )
            (pkgs.writers.writeNuBin "prefetch" # nu
              ''
                def main [...ids: string] {
                  $ids
                    | each { ${lib.getExe pkgs.nixVersions.latest} run github:Infinidoge/nix-minecraft#nix-modrinth-prefetch -- $in }
                    | print --raw
                }
              ''
            )
            (pkgs.writeShellApplication {
              name = "repair";
              runtimeInputs = [ pkgs.nixVersions.latest ];
              text = ''
                nix-store --verify --check-contents --repair
              '';
            })
          ];
      };
    };
}
