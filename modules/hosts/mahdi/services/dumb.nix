toplevel: {
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      imports = [ toplevel.config.flake.nixosModules.dumb ];

      services.traefik.dynamicConfigOptions.http = {
        routers.dumb = {
          rule = "Host(`dumb.${config.networking.domain}`)";
          service = "dumb";
        };
        services.dumb.loadBalancer.servers = [
          { url = "http://localhost:${toString config.services.dumb.port}"; }
        ];
      };

      services.dumb.enable = true;
    };
}
