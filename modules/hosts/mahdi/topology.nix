toplevel: {
  flake.aspects.hosts-mahdi.nixos =
    { config, ... }:
    let
      inherit (config.lib.topology) mkConnection;
      inherit (toplevel.config.lib.flake.util) getIcon;
    in
    {
      topology.self = {
        hardware = {
          image = getIcon {
            file = "poweredge-r730.png";
            type = "topology";
          };
          info = "DELL Poweredge R730";
        };
        interfaces.wlp130s0f0 = {
          physicalConnections = [ (mkConnection "router" "wifi") ];
          network = "home";
        };
      };
    };
}
