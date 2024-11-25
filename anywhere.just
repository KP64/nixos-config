[confirm("Are you sure you want to remote install?")]
install host ip user="root":
    @nom shell nixpkgs#nixos-anywhere --command nixos-anywhere --flake .#{{ host }} {{ user }}@{{ ip }}
