system := arch() + "-" + os()

[doc('Builds svgs in the result directory
containing the topology of the
config for the given system.')]
build:
    @nix shell nixpkgs#nix-output-monitor --command nom build .#topology.{{ system }}.config.output

[doc('Generates and shows main Topology in Terminal.
Requires a kitty Terminal.')]
show: build
    @nix shell nixpkgs#timg --command timg result/main.svg

[doc('Generates and Shows Network 🛜 in Terminal.
Requires a kitty Terminal.')]
net: build
    @nix shell nixpkgs#timg --command timg result/network.svg
