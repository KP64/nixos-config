repo := "github:mayniklas/eduroam-flake"

# List all university eduroam IDs
list:
  @- nix run {{ repo }}#list-eduroam-entityIDs

# Install the eduroam config
install university:
  @- nix run {{ repo }}#install-eduroam-{{ university }}
