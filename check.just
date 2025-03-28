# Run all Checks
all:
    just check flake
    just check links
    just check actions

# Check the flake
flake:
    @nix flake check

# Check links with lychee
links:
    @nix run nixpkgs#lychee ./*.md ./*.nix ./hosts/**/*.nix

# Check Github Actions
actions:
    @nix run nixpkgs#zizmor -- -p .github/workflows/
