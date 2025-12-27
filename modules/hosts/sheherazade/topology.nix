{ customLib, ... }:
{
  flake.modules.nixos.hosts-sheherazade =
    { config, ... }:
    let
      inherit (config.lib.topology) mkConnection;
    in
    {
      topology.self = {
        hardware = {
          image = customLib.util.getIcon {
            file = "rpi400.png";
            type = "topology";
          };
          info = "Raspberry Pi 400";
        };
        # TODO: Correct interface once it is on wifi again
        # interfaces.wlan0 = {
        #   physicalConnections = [ (mkConnection "router" "wifi") ];
        #   network = "home";
        # };
        # TODO: This should be the Dell remote controller later
        interfaces.end0 = {
          physicalConnections = [ (mkConnection "router" "LAN2") ];
          network = "home";
        };
      };
    };
}
