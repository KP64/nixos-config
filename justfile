default:
    @just --list

[group("dev")]
update *inputs:
    nix flake update {{ inputs }}

[group("utils")]
clean:
    nix-collect-garbage --delete-older-than 3d
    nix store optimise

[group("utils")]
repair:
    nix-store --verify --check-contents --repair
