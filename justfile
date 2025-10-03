# TODO: Move most if not all recipes to devshell stuff.
#       -> This (hopefully) allows us to bind variables like
#          experimental-features with the ones set in the config.

experimental-features := "nix-command flakes pipe-operators no-url-literals"

default:
    @just --list

[group("dev")]
update *inputs:
    nix flake update {{ inputs }}

[group("home-manager")]
freshinstall userHost:
    echo --experimental-features "{{ experimental-features }}" home-manager/master \
         -- --extra-experimental-features "{{ experimental-features }}" switch -b backup --flake .#"{{ userHost }}"

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
