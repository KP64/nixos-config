# Generates and if possible displays the network topology created by nix-topology
@example "Build topology" {topo}
@example $"Show (ansi yellow)main(ansi reset) topology" {topo main}
@example $"Show (ansi yellow)network(ansi reset) topology" {topo network}
def main [topology_type?: string]: nothing -> nothing {
    const all_topology_types = ["main" "network"]

    let chosen = if ($topology_type | is-empty) {
        null
    } else if $topology_type in $all_topology_types {
        $topology_type
    } else {
        $all_topology_types
        | each { $"(ansi yellow)($in)(ansi reset)" }
        | str join " or "
        | error make --unspanned $"No such topology. Should be either ($in)"
    }

    uname | nom build .#topology.($in.machine)-($in.kernel-name | str downcase).config.output
    if ($chosen | is-not-empty) {
        kitten icat result/($chosen).svg
    }
}
