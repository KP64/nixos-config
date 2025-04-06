{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.misc.transmission;
in
{
  options.services.misc.transmission.enable = lib.mkEnableOption "Transmission";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      xd
      rqbit
      transmission_4-gtk
    ];

    services.transmission = {
      enable = true;
      package = pkgs.transmission_4;
      group = "multimedia";
      settings.rpc-bind-address = "0.0.0.0";
      openRPCPort = true;
      openFirewall = true;
      openPeerPorts = true;
    };
  };
}
