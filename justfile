set unstable := true

mod anywhere
mod check
mod eduroam
mod pi
mod topology
mod sops
mod wsl

# 😺 you are seeing it right now
default:
    @just --choose

# Format the Whole Repo
fmt:
    @nix fmt
