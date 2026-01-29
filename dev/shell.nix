{ config, inputs, ... }:
{
  perSystem =
    {
      lib,
      pkgs,
      inputs',
      ...
    }:
    {
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
            (writeNuBin "topo" # nu
              ''
                def main [topology?: string]: nothing -> nothing {
                  const choices = [ "main" "network" ]

                  let chosen = if $topology == null {
                    $choices | input list -f "Topology"
                  } else if ($topology in $choices) {
                    $topology
                  } else {
                    $choices
                    | each { $"'($in)'" }
                    | str join " or "
                    | error make --unspanned {msg: $"No such topology. Should be either ($in)" }
                  }

                  if ($chosen | is-empty) {
                    uname | ${lib.getExe pkgs.nix-output-monitor} build .#topology.($in.machine)-($in.kernel-name | str downcase).config.output
                    kitten icat $"result/($chosen).svg"
                  }
                }
              ''
            )
            (
              let
                flakeInputs = inputs |> builtins.attrNames |> toString;
              in
              writeNuBin "upin" # nu
                ''
                  def main [...inputs: string]: nothing -> nothing {
                    const all_choices = [${flakeInputs}]

                    let selection = if ($inputs | is-not-empty) {
                      $inputs
                    } else {
                      $all_choices | input list -m "Inputs"
                    }

                    if ($selection | is-empty) {
                      return
                    }

                    $selection
                    | where $it not-in $all_choices
                    | each { error make --unspanned {msg: $"There is no Input named '($in)'" }}

                    ${lib.getExe pkgs.gum} confirm "Update?"
                    nix flake update ...(if $selection == $all_choices { [] } else { $selection })
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
                    | par-each { ${prefetch} $in }
                    | print --raw
                  }
                ''
            )
            (
              let
                inherit (config.flake) nixosConfigurations homeConfigurations;
                nixosConfigs =
                  nixosConfigurations
                  |> lib.mapAttrsToList (
                    hostName: value:
                    let
                      cfg = value.config;
                    in
                    {
                      host.${hostName} = cfg.allowedUnfreePackages;
                      users = cfg.home-manager.users |> lib.mapAttrs (_: uvalue: uvalue.allowedUnfreePackages);
                    }
                  );
                homeConfigs =
                  homeConfigurations
                  |> lib.mapAttrsToList (
                    homeName: value:
                    let
                      homeUser = lib.splitString "@" homeName;
                      username = builtins.head homeUser;
                      hostname = lib.last homeUser;
                    in
                    {
                      host = hostname;
                      users.${username} = value.config.allowedUnfreePackages;
                    }
                  );
              in
              writeNuBin "identify-unfree" { } # nu
                ''
                  def main [--json (-j)]: nothing -> oneof<table, string> {
                    let cfg_json = '${nixosConfigs ++ homeConfigs |> builtins.toJSON}'
                    if $json {
                      $cfg_json
                    } else {
                      $cfg_json | from json --strict
                    }
                  }

                  def "main host" [host: string]: nothing -> list<string> {
                    let data = identify-unfree -j | from json --strict

                    let host_exists = $data | any {|row|
                      if ($row.host | describe | str contains "record") {
                        $row.host | columns | get 0
                      } else {
                        $row.host
                      }
                      | $host == $in
                    }

                    if not $host_exists {
                      $"Host '($host)' not found"
                      | ansi gradient --fgstart "0xf9e2af" --fgend "0xf38ba8"
                      | error make --unspanned {msg: $in }
                    }

                    $data
                    | where { $in.host | describe | str starts-with "record" }
                    | each --flatten { $in.host | get --optional $host }
                  }
                ''
            )
          ];
      };
    };
}
