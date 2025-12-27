{ inputs, ... }:
{
  perSystem =
    {
      lib,
      pkgs,
      inputs',
      ...
    }:
    let
      prefixPath = packages: [
        "--prefix"
        "PATH"
        ":"
        (lib.makeBinPath packages)
      ];
    in
    {
      # TODO: Script that shows all unfree packages and which user/host uses them.
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
            (pkgs.writers.writeNuBin "topo"
              {
                makeWrapperArgs = prefixPath (
                  with pkgs;
                  [
                    gum
                    nixVersions.latest
                    timg
                  ]
                );
              }
              # nu
              ''
                def main [topology?: string]: nothing -> nothing {
                  let chosen = if $topology == null {
                    gum choose "main" "network";
                  } else if ([ "main" "network" ] | any {|t| $t == $topology }) {
                    $topology
                  } else {
                    error make --unspanned { msg: "No such topology. Should be either 'main' or 'network'" }
                  };
                  let path: path = $"result/($chosen).svg";
                  let architecture = uname | get machine;
                  let kernel_name = uname | get kernel-name | str downcase;
                  nix build .#topology.($architecture)-($kernel_name).config.output
                  if ($env.TERM? == "xterm-kitty") {
                    kitten icat $path;
                  } else {
                    timg $path;
                  }
                }
              ''
            )
            (pkgs.writers.writeNuBin "upin"
              {
                makeWrapperArgs = prefixPath (
                  with pkgs;
                  [
                    gum
                    nixVersions.latest
                  ]
                );
              }
              # nu
              ''
                def main [...inputs: string]: nothing -> nothing {
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
                def main [server: string]: nothing -> nothing {
                  sudo ${lib.getExe pkgs.tmux} -S /run/minecraft/($server).sock attach
                }
              ''
            )
            (pkgs.writers.writeNuBin "prefetch" # nu
              ''
                def main [...ids: string]: nothing -> nothing {
                  $ids
                    | par-each { ${lib.getExe inputs'.nix-minecraft.packages.nix-modrinth-prefetch} $in }
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
