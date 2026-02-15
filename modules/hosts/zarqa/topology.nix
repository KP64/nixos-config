toplevel: {
  flake.aspects.hosts-zarqa.nixos =
    { config, ... }:
    let
      inherit (config.lib.topology) mkConnection;
      inherit (toplevel.config.lib.flake.util) getIcon;
    in
    {
      topology.self = {
        hardware = {
          image = getIcon {
            file = "rpi3bp.png";
            type = "topology";
          };
          info = "Raspberry Pi 3 Model B+";
        };
        interfaces.wlan0 = {
          physicalConnections = [ (mkConnection "router" "wifi") ];
          network = "home";
        };
      };
    };
}
