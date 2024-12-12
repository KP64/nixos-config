repo := "github:mayniklas/eduroam-flake"

# List all university eduroam IDs
list:
  @- nix run {{ repo }}#list-eduroam-entityIDs

# Install the eduroam config
install university="bonn":
  @- nix run {{ repo }}#install-eduroam-{{ university }}
