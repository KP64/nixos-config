{ inputs, self, ... }: {
  flake-file.inputs.nix-topology = {
    type = "github";
    owner = "oddlama";
    repo = "nix-topology";
    inputs = {
      flake-parts.follows = "flake-parts";
      nixpkgs.follows = "nixpkgs";
    };
  };

  imports = [ inputs.nix-topology.flakeModule ];

  den.default.nixos = {
    imports = [ inputs.nix-topology.nixosModules.default ];
    topology.self.services.openssh.hidden = false;
  };

  perSystem.topology.modules = [
    (
      { config, ... }:
      let
        topologyLib = config.lib.topology;
      in
      {
        nodes = {
          internet = topologyLib.mkInternet { };
          modem = {
            name = "DSL-Modem";
            deviceType = "device";
            interfaces = {
              DSL.physicalConnections = [ (topologyLib.mkConnection "internet" "*") ];
              p1 = { };
              p2 = { };
            };
            hardware = {
              info = "DreyTek Vigor167";
              image = builtins.path {
                path = "${self}/assets/topology/vigor167.png";
                recursive = false;
                sha256 = "sha256-XaP99vGadXkLyXhVEkBm6bkn3o8Zux1ht2m3CQA5q1Y=";
              };
            };
          };
          router = topologyLib.mkRouter "Router" {
            info = "Fritz!Box 4630";
            image = builtins.path {
              path = "${self}/assets/topology/fritzbox4630.png";
              recursive = false;
              sha256 = "sha256-um6RhXg6JJEztd17p6YLwGPxPXJkllvpq/SKD9im5WM=";
            };
            interfaceGroups = [
              [ "WAN" ]
              [ "wifi" ]
              (builtins.genList (i: "LAN${toString (i + 1)}") 3)
            ];
            connections.WAN = topologyLib.mkConnection "modem" "p2";
          };
        };
        networks.home = {
          name = "Home Network";
          cidrv4 = "192.168.178.0/24";
          cidrv6 = "fd34:683f:dc06:0::/64";
        };
      }
    )
  ];
}
