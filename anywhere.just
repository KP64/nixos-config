[confirm("Are you sure you want to remote install?")]
install host ip user="root":
    @nix shell nixpkgs#nixos-anywhere --command nixos-anywhere --flake .#{{ host }} {{ user }}@{{ ip }}
