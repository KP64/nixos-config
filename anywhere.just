[confirm("Are you sure you want to remote install?")]
install host ip user="root":
    @nix run nixpkgs#nixos-anywhere -- --flake .#{{ host }} {{ user }}@{{ ip }}
