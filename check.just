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
    @lychee ./*.md ./*.nix ./hosts/**/*.nix --include-fragments

# Check Github Actions
actions:
    @zizmor -p .github/workflows/
