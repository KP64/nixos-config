toplevel: {
  den.aspects.morgiana.nixos =
    { config, ... }:
    let
      inherit (config.lib.topology) mkConnection;
      inherit (toplevel.config.lib.flake.util) getAsset;
    in
    {
      topology.self = {
        hardware = {
          image = getAsset {
            file = "rpi4.png";
            type = "topology";
            sha256 = "sha256-j5iz74ZciI00wOIwlR1sOpHnDVhnkDhPCQ/cK8GsxrU=";
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
