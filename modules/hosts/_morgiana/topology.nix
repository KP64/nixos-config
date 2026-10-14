toplevel: {
  den.aspects.morgiana.nixos =
    let
      inherit (toplevel.config.lib.flake.util) getAsset;
    in
    {
      topology.self = {
        hardware = {
          image = getAsset {
            file = "rpi4.png";
            type = "topology";
            sha256 = "sha256-j5iz74ZciI00wOIwlR1sOpHnDVhnkDhPCQ/cK8GsxrU=";
          };
          info = "Raspberry Pi 4 Model B";
        };
        interfaces.wlan0.network = "home";
      };
    };
}
