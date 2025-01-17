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
    @nix shell nixpkgs#lychee -command lychee ./*.md ./*.nix ./hosts/**/*.nix

# Check Github Actions
actions:
    @nix shell nixpkgs#zizmor -command zizmor -p .github/workflows/
