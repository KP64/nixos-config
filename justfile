default:
    @just --list

[group("dev")]
update *inputs:
    nix flake update {{ inputs }}

[group("minecraft")]
attach server:
    sudo nix run nixpkgs#tmux -- -S /run/minecraft/{{ server }}.sock attach

[group("minecraft")]
prefetch versionid:
    nix run github:Infinidoge/nix-minecraft#nix-modrinth-prefetch -- {{ versionid }}

[group("utils")]
clean:
    nix-collect-garbage --delete-older-than 3d
    nix store optimise

[group("utils")]
repair:
    nix-store --verify --check-contents --repair
