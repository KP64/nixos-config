{ customLib, ... }:
{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    let
      inherit (config.lib.topology) mkConnection;
    in
    {
      topology.self = {
        hardware = {
          image = customLib.util.getIcon {
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
