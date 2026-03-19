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

            catppuccinMocha = {
              yellow = "0xf9e2af";
              red = "0xf38ba8";
            };
          in
          (with pkgs; [
            nil
            yaml-language-server
            vscode-json-languageserver
            kdePackages.qtdeclarative # qmlls

            nix-melt
            nix-output-monitor
          ])
          ++ [
            (writeNuBin "topo" # nu
              ''
                def main [topology?: string]: nothing -> nothing {
                  const choices = [ "main" "network" ]

                  let chosen = if ($topology | is-empty) {
                    let temp = $choices | input list --fuzzy "Topology"
                    if ($temp | is-empty) {
                      return
                    }
                    $temp
                  } else if ($topology in $choices) {
                    $topology
                  } else {
                    $choices
                    | each {|| ansi gradient --fgstart "${catppuccinMocha.yellow}" --fgend "${catppuccinMocha.red}" }
                    | each { $"'($in)'" }
                    | str join " or "
                    | error make --unspanned $"No such topology. Should be either ($in)"
                  }

                  uname | ${lib.getExe pkgs.nix-output-monitor} build .#topology.($in.machine)-($in.kernel-name | str downcase).config.output
                  kitten icat $"result/($chosen).svg"
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
                    const all_choices = [ ${flakeInputs} ]

                    let selection = if ($inputs | is-not-empty) {
                      $inputs
                    } else {
                      $all_choices | input list --fuzzy --multi "Inputs"
                    }

                    if ($selection | is-empty) {
                      return
                    }

                    $selection
                    | where $it not-in $all_choices
                    | each {|| ansi gradient --fgstart "${catppuccinMocha.yellow}" --fgend "${catppuccinMocha.red}" }
                    | each { error make --unspanned $"There is no Input named '($in)'" }

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
                    let cfg_json = '${builtins.toJSON (nixosConfigs ++ homeConfigs)}'
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
                      $host
                      | ansi gradient --fgstart "${catppuccinMocha.yellow}" --fgend "${catppuccinMocha.red}"
                      | $"Host '($in)' not found"
                      | error make --unspanned $in
                    }

                    $data
                    | where { $in.host | describe | str starts-with "record" }
                    | each --flatten { $in.host | get --optional $host }
                  }
                ''
            )
            (writeNuBin "deploy"
              {
                makeWrapperArgs = [
                  "--prefix"
                  "PATH"
                  ":"
                  (lib.makeBinPath (
                    with pkgs;
                    [
                      sops
                      git
                      ssh-to-age
                      nixos-anywhere
                      openssh
                    ]
                  ))
                ];
              }
              # nu
              ''
                def main [host: string, ip: string, ...args: string]: nothing -> nothing {
                  # Work on raw YAML text for anchors
                  let raw = open --raw .sops.yaml

                  let anchor = $"host_($host)"
                  if not ($raw | str contains $"&($anchor)") {
                    error make $"Host anchor ($anchor) not found in .sops.yaml"
                  }

                  let old_age_key = $raw
                    | parse --regex $"&($anchor) \(?<key>age[0-9a-z]+\)"
                    | get key.0
                  if ($old_age_key | is-empty) {
                    error make $"Failed to extract old age key for ($anchor)"
                  }

                  # Create temp dir
                  let tempdir = mktemp -d
                  let ssh_dir = ($tempdir)/etc/ssh
                  mkdir $ssh_dir

                  let rsa_key = $"($ssh_dir)/ssh_host_rsa_key"
                  let ed25519_key = $"($ssh_dir)/ssh_host_ed25519_key"

                  ssh-keygen -t rsa -b 4096 -f $rsa_key -N "" -C $host
                  ssh-keygen -t ed25519 -f $ed25519_key -N "" -C $host

                  let age_pub = open --raw $"($ed25519_key).pub" | ssh-to-age

                  # Replace anchor in raw YAML
                  $raw
                  | str replace -r $"&($anchor) age[0-9a-z]+" $"&($anchor) ($age_pub)"
                  | save --force .sops.yaml

                  print $"Updated .sops.yaml for ($host)"

                  let git_files = git ls-files | lines

                  (open .sops.yaml).creation_rules
                  | where {|rule|
                      $rule.key_groups | any {|kg|
                        $kg.age | any {|k| $k == $age_pub }
                      }
                    }
                  | get path_regex
                  | par-each {|regex| $git_files | where {|f| $f =~ $regex } }
                  | flatten
                  | uniq
                  | each {|file_to_reencrypt|
                    print $"Re-encrypting ($file_to_reencrypt)"
                    sops updatekeys $file_to_reencrypt
                    print # needed so that updatekeys output is shown
                  }

                  nixos-anywhere --flake $".#($host)" --target-host $"root@($ip)" --extra-files $tempdir ...$args

                  # Remove lingering temp directory.
                  # We only care about the successful case because
                  # failing means the keys won't be used anyway
                  rm -rf $tempdir
                }
              ''
            )
          ];
      };
    };
}
