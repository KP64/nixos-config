{
  den.aspects.virtualisation._.podman.nixos = { user, config, ... }: {
    users.users.${user.userName}.extraGroups = [ config.users.groups.podman.name ];

    virtualisation.podman = {
      enable = true;
      dockerCompat = with config.virtualisation.docker; !enable && !rootless.enable;
      autoPrune.enable = true;
      defaultNetwork.settings = {
        name = "podman";
        dns_enabled = true;
        ipv6_enabled = true;
        subnets = [
          {
            gateway = "fd00:d:a5::1";
            subnet = "fd00:d:a5::/64";
          }
        ];
      };
    };
  };
}
