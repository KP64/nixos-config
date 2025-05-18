{ config, lib, ... }:
let
  cfg = config.services.networking.i2p;
in
{
  options.services.networking.i2p.enable = lib.mkEnableOption "I2p";

  config.services.i2pd = {
    inherit (cfg) enable;
    address = "0.0.0.0"; # For SSH-Tunnels
    bandwidth = 2048; # kbps
    reseed.verify = true;
    websocket.enable = true;
    proto = {
      http.enable = true;
      httpProxy.enable = true;
      i2cp.enable = true;
      sam.enable = true;
      socksProxy.enable = true;
    };
  };
}
