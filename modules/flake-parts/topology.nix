toplevel@{ inputs, ... }:
{
  imports = [ inputs.nix-topology.flakeModule ];

  perSystem.topology.modules = toplevel.lib.singleton (
    { config, ... }:
    let
      topologyLib = config.lib.topology;
      inherit (toplevel.config.lib.flake.util) getIcon;
    in
    {
      nodes = {
        internet = topologyLib.mkInternet { connections = topologyLib.mkConnectionRev "router" "WAN1"; };
        router = topologyLib.mkRouter "Speedport" {
          info = "Smart 4";
          image = getIcon {
            file = "speedport.png";
            type = "topology";
          };
          interfaceGroups = [
            [ "wifi" ]
            [ "Link/LAN1" ]
            (3 |> builtins.genList (i: "LAN${toString <| i + 2}"))
            [ "WAN1" ]
          ];
        };
      };
      networks.home = {
        name = "Home Network";
        cidrv4 = "192.168.2.0/24";
      };
    }
  );
}
