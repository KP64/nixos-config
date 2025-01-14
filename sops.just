# Create/Edit 'secrets.yaml' for a user
edit host:
    @- nom shell nixpkgs#sops --command sops hosts/{{ host }}/secrets.yaml


# Update 'secrets.yaml' for a user
update host:
    @- nom shell nixpkgs#sops --command sops updatekeys hosts/{{ host }}/secrets.yaml
