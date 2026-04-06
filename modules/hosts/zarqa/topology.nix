toplevel: {
  flake.modules.nixos.hosts-zarqa =
    { config, ... }:
    let
      inherit (config.lib.topology) mkConnection;
      inherit (toplevel.config.lib.flake.util) getAsset;
    in
    {
      topology.self = {
        hardware = {
          image = getAsset {
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
