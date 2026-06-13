# Updates the current directory's flake inputs
@example "Interactive input selection" {upin}
@example "Update single input" {upin nixpkgs}
@example "Update multiple inputs" {upin nixpkgs disko}
def main [...inputs_to_update: string]: nothing -> nothing {
    let all_inputs = nix eval --file flake.nix inputs --apply builtins.attrNames --json | from json --strict

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

    gum confirm "Update?"
    nix flake update --accept-flake-config ...(if $selection == $all_inputs { [] } else { $selection })
}
