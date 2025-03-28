system := arch() + "-" + os()

[doc('Builds svgs in the result directory
containing the topology of the
config for the given system.')]
build:
    @nix run nixpkgs#nix-output-monitor build .#topology.{{ system }}.config.output

[doc('Generates and shows main Topology in Terminal.
Requires a kitty Terminal.')]
show: build
    @nix run nixpkgs#timg result/main.svg

[doc('Generates and Shows Network 🛜 in Terminal.
Requires a kitty Terminal.')]
net: build
    @nix run nixpkgs#timg result/network.svg
