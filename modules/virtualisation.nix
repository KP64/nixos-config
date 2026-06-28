{
  den.aspects.virtualisation._ = {
    podman = {
      _.to-users.user.extraGroups = [ "podman" ];

      nixos = { config, ... }: {
        virtualisation.podman = {
          enable = true;
          dockerCompat = with config.virtualisation.docker; !enable && !rootless.enable;
          autoPrune.enable = true;
          defaultNetwork.settings = {
            dns_enabled = true;
          };
        };
      };
    };

    docker = {
      _.to-users.user.extraGroups = [ "docker" ];

      nixos = _: {
        virtualisation.docker = {
          autoPrune = {
            enable = true;
            allVolumes.enable = true;
          };
          rootless = {
            enable = true;
            setSocketVariable = true;
          };
        };
      };
    };
  };
}
