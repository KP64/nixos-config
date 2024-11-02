
[confirm("Are you sure you want to remote install?")]
install host ip user="root":
    nix run github:nix-community/nixos-anywhere -- --flake .#{{ host }} {{ user }}@{{ ip }}
