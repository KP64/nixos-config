toplevel: {
  flake.modules.nixos.hosts-morgiana =
    { config, ... }:
    let
      inherit (config.lib.topology) mkConnection;
      inherit (toplevel.config.lib.flake.util) getIcon;
    in
    {
      topology.self = {
        hardware = {
          image = getIcon {
            file = "rpi4.png";
            type = "topology";
          };
          info = "Raspberry Pi 4 Model B";
        };
        interfaces.wlan0 = {
          physicalConnections = [ (mkConnection "router" "wifi") ];
          network = "home";
        };
      };
    };
}
