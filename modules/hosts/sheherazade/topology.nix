toplevel: {
  flake.modules.nixos.hosts-sheherazade =
    { config, ... }:
    let
      inherit (config.lib.topology) mkConnection;
      inherit (toplevel.config.lib.flake.util) getAsset;
    in
    {
      topology.self = {
        hardware = {
          image = getAsset {
            file = "rpi400.png";
            type = "topology";
          };
          info = "Raspberry Pi 400";
        };
        interfaces.wlan0 = {
          physicalConnections = [ (mkConnection "router" "wifi") ];
          network = "home";
        };
      };
    };
}
