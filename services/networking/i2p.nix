{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.networking.i2p;
in
{
  options.services.networking.i2p.enable = lib.mkEnableOption "I2p";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
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
        # credentialsFile = config.sops.secrets."transmission/settings.json".path;
      };

      services.i2pd = {
        enable = true;
        address = "0.0.0.0";
        proto = {
          http.enable = true;
          httpProxy.enable = true;
          socksProxy.enable = true;
          sam.enable = true;
          i2cp = {
            enable = true;
            address = "0.0.0.0";
            port = 7654;
          };
        };
      };
    })

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".directories = lib.optionals cfg.enable [
        config.services.transmission.home
        "/var/lib/i2pd"
      ];
    })
  ];
}
