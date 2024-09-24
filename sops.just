# Create/Edit 'secrets.yaml' for a user
edit host:
    @- sops hosts/{{ host }}/secrets.yaml


# Update 'secrets.yaml' for a user
update host:
    @- sops updatekeys hosts/{{ host }}/secrets.yaml
