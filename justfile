# 😺 you are seeing it right now
default:
  just --list

[doc(
  'Builds svgs in the result directory
containing the topology of the
config for the given system.')]
build-topology system="x86_64-linux":
  nix build .{{"#"}}topology.{{system}}.config.output

[doc(
  'Generates and shows main Topology in Terminal.
Requires a kitty Terminal.'
)]
show system="x86_64-linux": (build-topology system)
  kitten icat result/main.svg

[doc(
  'Generates and Shows Network in Terminal.
Requires a kitty Terminal.'
)]
net system="x86_64-linux": (build-topology system)
  kitten icat result/network.svg

pi:
  nix build .{{ "#" }}nixosConfigurations.nixos-pi-installer.config.system.build.sdImage --show-trace -L -v
