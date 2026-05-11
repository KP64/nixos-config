toplevel@{ inputs, self, ... }:
{
  imports = [ inputs.nix-topology.flakeModule ];

  perSystem.topology.modules = toplevel.lib.singleton (
    { config, ... }:
    let
      topologyLib = config.lib.topology;
    in
    {
      nodes = {
        internet = topologyLib.mkInternet { connections = topologyLib.mkConnectionRev "router" "WAN1"; };
        router = topologyLib.mkRouter "Speedport" {
          info = "Smart 4";
          image = builtins.path {
            path = "${self}/assets/topology/speedport.png";
            recursive = false;
            sha256 = "sha256-c7E+g1uS4xYwEtYjFnU5/Bt6IQ907ioPEfSm49YOxJk=";
          };
          interfaceGroups = [
            [ "wifi" ]
            [ "Link/LAN1" ]
            (builtins.genList (i: "LAN${toString (i + 2)}") 3)
            [ "WAN1" ]
          ];
        };
      };
      networks.home = {
        name = "Home Network";
        cidrv4 = "192.168.2.0/24";
        cidrv6 = "fdef:fa6a:4724:1::/64";
      };
    }
  );
}
