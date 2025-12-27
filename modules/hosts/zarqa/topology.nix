{ customLib, ... }:
{
  flake.modules.nixos.hosts-zarqa =
    # { config, ... }:
    # let
    #   inherit (config.lib.topology) mkConnection;
    # in
    {
      topology.self = {
        hardware = {
          image = customLib.util.getIcon {
            file = "rpi3bp.png";
            type = "topology";
          };
          info = "Raspberry Pi 3 Model B+";
        };
        # TODO: Enable once ready
        # interfaces.wlan0 = {
        #   physicalConnections = [ (mkConnection "router" "wifi") ];
        #   network = "home";
        # };
      };
    };
}
