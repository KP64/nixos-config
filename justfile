# 😺 you are seeing it right now
default:
    @just --list

default_system := "x86_64-linux"

[doc('Builds svgs in the result directory
containing the topology of the
config for the given system.')]
build-topology system=default_system:
    nix build .{{ "#" }}topology.{{ system }}.config.output

[doc('Generates and shows main Topology in Terminal.
Requires a kitty Terminal.')]
show system=default_system: (build-topology system)
    kitten icat result/main.svg

[doc('Generates and Shows Network in Terminal.
Requires a kitty Terminal.')]
net system=default_system: (build-topology system)
    kitten icat result/network.svg

# Builds an sd-Image for nixos on a raspberry pi
pi:
    nix build .{{ "#" }}nixosConfigurations.nixos-pi-installer.config.system.build.sdImage --show-trace -L -v
