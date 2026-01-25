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
        # Required for qmlls to find the correct type declarations
        QMLLS_BUILD_DIRS = lib.concatMapStringsSep ":" (p: "${p}/lib/qt-6/qml/") (
          with pkgs;
          [
            kdePackages.qtdeclarative
            quickshell
          ]
        );

        packages =
          let
            inherit (pkgs.writers) writeNuBin;
          in
          (with pkgs; [
            nil
            yaml-language-server
            vscode-json-languageserver
            kdePackages.qtdeclarative # qmlls

            nix-melt
          ])
          ++ [
            (writeNuBin "topo"
              {
                makeWrapperArgs = prefixPath (
                  with pkgs;
                  [
                    gum
                    nix-output-monitor
                    timg
                  ]
                );
              } # nu
              ''
                def main [topology?: string]: nothing -> nothing {
                  const choices = [ "main" "network" ]
                  let chosen = if $topology == null {
                    gum choose ...$choices
                  } else if ($choices | any {|t| $t == $topology }) {
                    $topology
                  } else {
                    let choosable = $choices | each {|choice| $"'($choice)'" } | str join " or "
                    error make --unspanned {msg: $"No such topology. Should be either ($choosable)" }
                  }

                  let architecture = uname | get machine
                  let kernel_name = uname | get kernel-name | str downcase
                  nom build .#topology.($architecture)-($kernel_name).config.output

                  let path: path = $"result/($chosen).svg"
                  if $env.TERM? == "xterm-kitty" {
                    kitten icat $path
                  } else {
                    timg $path
                  }
                }
              ''
            )
            (
              let
                flakeInputs = inputs |> builtins.attrNames |> toString;
              in
              writeNuBin "upin" { makeWrapperArgs = prefixPath [ pkgs.gum ]; } # nu
                ''
                  def main [...inputs: string]: nothing -> nothing {
                    let selection = if not ($inputs | is-empty) {
                      $inputs
                    } else {
                      # If nothing is chosen then a list with an empty string is returned...
                      let chosen = gum choose --no-limit --header "Inputs" ${flakeInputs} | lines --skip-empty
                      if $chosen == [ "" ] {
                        [ ]
                      } else {
                        $chosen
                      }
                    }

                    if ($selection | is-empty) {
                      return
                    }

                    if $selection == [${flakeInputs}] {
                      gum confirm "Update all Inputs?" ; nix flake update
                    } else {
                      gum confirm "Update?" ; nix flake update ...$selection
                    }
                  }
                ''
            )
            (writeNuBin "attach" # nu
              ''
                def main [server: string]: nothing -> nothing {
                  sudo ${lib.getExe pkgs.tmux} -S /run/minecraft/($server).sock attach
                }
              ''
            )
            (
              let
                prefetch = lib.getExe inputs'.nix-minecraft.packages.nix-modrinth-prefetch;
              in
              writeNuBin "prefetch" # nu
                ''
                  def main [...ids: string]: nothing -> nothing {
                    $ids
                      | par-each {|id| ${prefetch} $id }
                      | print --raw
                  }
                ''
            )
          ];
      };
    };
}
