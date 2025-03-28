# Create/Edit 'secrets.yaml' for a user
edit host:
    @- nix run nixpkgs#sops hosts/{{ host }}/secrets.yaml

# Update 'secrets.yaml' for a user
update host:
    @- nix run nixpkgs#sops updatekeys hosts/{{ host }}/secrets.yaml
