# Create/Edit 'secrets.yaml' for a user
edit host:
    @- nix shell nixpkgs#sops --command sops hosts/{{ host }}/secrets.yaml

# Update 'secrets.yaml' for a user
update host:
    @- nix shell nixpkgs#sops --command sops updatekeys hosts/{{ host }}/secrets.yaml
