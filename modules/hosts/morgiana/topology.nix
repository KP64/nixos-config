{ customLib, ... }:
{
  flake.modules.nixos.hosts-morgiana =
    # { config, ... }:
    # let
    #   inherit (config.lib.topology) mkConnection;
    # in
    {
      topology.self = {
        hardware = {
          image = customLib.util.getIcon {
            file = "rpi4.png";
            type = "topology";
          };
          info = "Raspberry Pi 4 Model B";
        };
        # TODO: Enable once ready
        # interfaces.wlan0 = {
        #   physicalConnections = [ (mkConnection "router" "wifi") ];
        #   network = "home";
        # };
      };
    };
}
