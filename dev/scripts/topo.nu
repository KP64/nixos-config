# Generates and if possible displays the network topology created by nix-topology
@example "Build topology" {topo}
@example $"Show (ansi yellow)main(ansi reset) topology" {topo main}
@example $"Show (ansi yellow)network(ansi reset) topology" {topo network}
def main [topology_type?: string]: nothing -> nothing {
    const all_topology_types = ["main" "network"]

    nom build .#topology.((uname).machine)-((uname).kernel-name | str lowercase).config.output --accept-flake-config

    let chosen = if ($topology_type | is-empty) {
        return
    } else if $topology_type in $all_topology_types {
        $topology_type
    } else {
        $all_topology_types
        | each { $"(ansi yellow)($in)(ansi reset)" }
        | str join " or "
        | error make --unspanned $"No such topology. Should be either ($in)"
    }
    kitten icat result/($chosen).svg
}
