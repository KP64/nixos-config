toplevel: {
  den.aspects.mahdi.nixos =
    { config, ... }:
    let
      inherit (config.lib.topology) mkConnection;
      inherit (toplevel.config.lib.flake.util) getAsset;
    in
    {
      topology.self = {
        hardware = {
          image = getAsset {
            file = "poweredge-r730.png";
            type = "topology";
            sha256 = "sha256-aS3wAebz8cZrF7Vov3wT/Q69AD/tmrC2EIrrZGimGA0=";
          };
          info = with config.hardware.facter.report.smbios.system; "${manufacturer} ${product}";
        };
        interfaces.wlp130s0f0 = {
          physicalConnections = [ (mkConnection "router" "wifi") ];
          network = "home";
        };
      };
    };
}
