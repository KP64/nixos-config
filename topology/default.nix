{ config, ... }:
let
  inherit (config.lib) topology;
in
{
  networks.home = {
    name = "Home";
    cidrv4 = "192.168.2.0/24";
  };

  nodes = {
    internet = topology.mkInternet { connections = topology.mkConnection "router" "wan"; };

    router = topology.mkRouter "Speedport" {
      info = "Speedport Smart 4";
      image = ./speedport.png;
      interfaceGroups = [
        [ "wifi" ]
        [ "wan" ]
        [
          "eth1"
          "eth2"
          "eth3"
        ]
      ];
    };
  };
}
