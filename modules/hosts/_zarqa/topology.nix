toplevel: {
  den.aspects.zarqa.nixos =
    let
      inherit (toplevel.config.lib.flake.util) getAsset;
    in
    {
      topology.self = {
        hardware = {
          image = getAsset {
            file = "rpi3bp.png";
            type = "topology";
            sha256 = "sha256-M1hSQ67UY5vRbCLJ7AhUdV/V+wkSoiuKDNskTFtDGGs=";
          };
          info = "Raspberry Pi 3 Model B+";
        };
        interfaces.wlan0.network = "home";
      };
    };
}
