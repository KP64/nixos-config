# Generates and if possible displays the network topology created by nix-topology
@example "Interactive topology type selection" {topo}
@example $"Show (ansi yellow)main(ansi reset) topology" {topo main}
@example $"Show (ansi yellow)network(ansi reset) topology" {topo network}
def main [topology_type?: string]: nothing -> nothing {
    const all_topology_types = ["main" "network"]

    let chosen = if ($topology_type | is-empty) {
        let temp = $all_topology_types | input list --fuzzy "Topology"
        if ($temp | is-empty) {
            return
        }
        $temp
    } else if $topology_type in $all_topology_types {
        $topology_type
    } else {
        $all_topology_types
        | each { $"(ansi yellow)($in)(ansi reset)" }
        | str join " or "
        | error make --unspanned $"No such topology. Should be either ($in)"
    }

    uname | nom build .#topology.($in.machine)-($in.kernel-name | str downcase).config.output
    kitten icat result/($chosen).svg
}
