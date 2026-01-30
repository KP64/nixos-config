toplevel: {
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    let
      inherit (config.lib.topology) mkConnection;
      inherit (toplevel.config.flake.lib.flake) getIcon;
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
