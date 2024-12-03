set unstable := true

mod anywhere
mod eduroam
mod pi
mod topology
mod sops
mod wsl

# 😺 you are seeing it right now
default:
    @just --choose

check:
    @- nix flake check

fmt:
    @nix fmt

links:
    @lychee ./*.nix ./hosts/**/*.nix --include-fragments
