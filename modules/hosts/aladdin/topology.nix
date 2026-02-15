{
  flake.aspects.hosts-aladdin.nixos =
    { config, ... }:
    let
      inherit (config.lib.topology) mkConnection;
    in
    {
      topology.self = {
        hardware.info = "Ryzen 7 2700X";
        interfaces.wlp6s0 = {
          physicalConnections = [ (mkConnection "router" "wifi") ];
          network = "home";
        };
      };
    };
}
