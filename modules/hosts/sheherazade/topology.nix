toplevel: {
  den.aspects.sheherazade.nixos =
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
            sha256 = "sha256-B9frbraTDwtBlundqLEPbm3X8IjH/i9yk5CQJ8k4kgE=";
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
