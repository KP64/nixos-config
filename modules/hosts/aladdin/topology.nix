{
  den.aspects.aladdin.nixos =
    { config, ... }:
    let
      inherit (config.lib.topology) mkConnection;
    in
    {
      topology.self = {
        hardware.info = (builtins.head config.hardware.facter.report.hardware.cpu).model_name;
        interfaces.wlp6s0 = {
          physicalConnections = [ (mkConnection "router" "wifi") ];
          network = "home";
        };
      };
    };
}
