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

        packages =
          let
            inherit (pkgs.writers) writeNuBin;
          in
          (with pkgs; [
            nil
            yaml-language-server
            vscode-json-languageserver

            nix-init
            nix-melt
            nix-output-monitor
          ])
          ++ [
            (writeNuBin "topo" # nu
              ''
                # Generates and if possible displays the network topology created by nix-topology
                @example "Interactive topology type selection" {topo}
                @example $"Show (ansi yellow)main(ansi reset) topology" {topo main}
                @example $"Show (ansi yellow)network(ansi reset) topology" {topo network}
                def main [topology_type?: string]: nothing -> nothing {
                    const all_topology_types = [ "main" "network" ]

                    let chosen = if ($topology_type | is-empty) {
                        let temp = $all_topology_types | input list --fuzzy "Topology"
                        if ($temp | is-empty) {
                            return
                        }
                        $temp
                    } else if ($topology_type in $all_topology_types) {
                        $topology_type
                    } else {
                        $all_topology_types
                        | each { $"(ansi yellow)($in)(ansi reset)" }
                        | str join " or "
                        | error make --unspanned $"No such topology. Should be either ($in)"
                    }

                    uname | ${lib.getExe pkgs.nix-output-monitor} build .#topology.($in.machine)-($in.kernel-name | str downcase).config.output
                    ${lib.getExe' pkgs.kitty "kitten"} icat result/($chosen).svg
                }
              ''
            )
            (writeNuBin "upin" # nu
              ''
                # Updates the current directory's flake inputs
                @example "Interactive input selection" {upin}
                @example "Update single input" {upin nixpkgs}
                @example "Update multiple inputs" {upin nixpkgs disko}
                def main [...inputs_to_update: string]: nothing -> nothing {
                    let all_inputs = ${lib.getExe pkgs.nixVersions.latest} eval --file flake.nix inputs --apply builtins.attrNames --json | from json --strict

                    let selection = if ($inputs_to_update | is-not-empty) {
                        $inputs_to_update
                    } else {
                        $all_inputs | input list --fuzzy --multi "Inputs"
                    }

                    if ($selection | is-empty) {
                        return
                    }

                    $selection
                    | where $it not-in $all_inputs
                    | each { error make --unspanned $"There is no input named (ansi yellow)($in)(ansi reset)" }

                    ${lib.getExe pkgs.gum} confirm "Update?"
                    ${lib.getExe pkgs.nixVersions.latest} flake update ...(if $selection == $all_inputs { [] } else { $selection })
                }
              ''
            )
            (writeNuBin "attach" # nu
              ''
                # Connects to the console of a running minecraft server via tmux
                @example $"Connect to server named (ansi yellow)Survival(ansi reset)" {attach Survival}
                def main [server_to_connect_to: string]: nothing -> nothing {
                    sudo ${lib.getExe pkgs.tmux} -S /run/minecraft/($server_to_connect_to).sock attach
                }
              ''
            )
            (
              let
                prefetch = lib.getExe inputs'.nix-minecraft.packages.nix-modrinth-prefetch;
              in
              writeNuBin "prefetch" # nu
                ''
                  # Fetches the mods' URLs and their hash from modrinth via their IDs
                  #
                  # To get the ID of a mod visit the exact version of the mod
                  # you want to install and scroll down. You will find it under the
                  # `Version ID` section immediately under the publisher
                  @example $"Fetch (ansi yellow)Fabric API 0.116.9+1.21.1(ansi reset)" {prefetch yGAe1owa}
                  def main [...mod_ids: string]: nothing -> nothing {
                      $mod_ids | par-each { ${prefetch} $in } | print --raw
                  }
                ''
            )
            # TODO: Add after deployment steps:
            #       1. User/Admin sops should be configured correctly
            #       2. Reboot after installation again, because home-manager is weird
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
                      gitMinimal
                      ssh-to-age
                      nixos-anywhere
                      openssh
                    ]
                  ))
                ];
              }
              # nu
              ''
                # A deployment script utilizing nixos-anywhere
                #
                # 1. Generates new SSH and Age Keys
                # 2. Updates all secrets of that host
                # 3. Deploys config with new Keys
                @example "Deploy Zarqa" {deploy zarqa 192.168.2.201}
                @example "Deploy Zarqa and generate facter.json" {deploy zarqa 192.168.2.201 --generate-hardware-report}
                def main [host: string, ip: string, --generate-hardware-report]: nothing -> nothing {
                    # Work on raw YAML text for anchors
                    let raw = open --raw .sops.yaml

                    let anchor = $"host_($host)"
                    if not ($raw | str contains $"&($anchor)") {
                        error make $"Host anchor ($anchor) not found in .sops.yaml"
                    }

                    let old_age_key = $raw | parse --regex $"&($anchor) \(?<key>age[0-9a-z]+\)" | get key.0
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

                    ".sops.yaml"
                    | open
                    | get creation_rules
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

                    nixos-anywhere --flake $".#($host)" (if $generate_hardware_report { $"--generate-hardware-config nixos-facter ./modules/hosts/($host)/facter.json" } else { "" }) --target-host $"root@($ip)" --extra-files $tempdir

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
