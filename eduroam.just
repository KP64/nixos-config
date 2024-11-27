repo := "github:mayniklas/eduroam-flake"

list:
  @- nix run {{ repo }}#list-eduroam-entityIDs

install university="bonn":
  @- nix run {{ repo }}#install-eduroam-{{ university }}
