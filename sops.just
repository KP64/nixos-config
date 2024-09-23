# Create a 'secrets.yaml' File for the specified user
create host:
    sops hosts/{{ host }}/secrets.yaml


# Update the secrets.yaml File for the specified user
update host:
    sops updatekeys hosts/{{ host }}/secrets.yaml
