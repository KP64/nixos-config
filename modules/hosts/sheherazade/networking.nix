{
  flake.modules.nixos.hosts-sheherazade =
    { config, lib, ... }:
    {
      sops.secrets."wireless.env".owner = config.users.users.wpa_supplicant.name;

      networking = {
        domain = "srvd.space";
        resolvconf.useLocalResolver = true;
        useNetworkd = true;
        useDHCP = false;
        wireless = {
          enable = true;
          secretsFile = config.sops.secrets."wireless.env".path;
          fallbackToWPA2 = false;
          scanOnLowSignal = false;
          networks.Home-5GHz.pskRaw = "ext:HOME_WIFI_PASSWORD";
        };
      };

      # We don't care which interface is online here
      systemd.network.wait-online.anyInterface = true;
      boot.initrd.systemd.network.wait-online.anyInterface = true;

      systemd.network = {
        enable = true;
        networks."10-wlan0" = {
          name = "wlan0";
          linkConfig.RequiredForOnline = "routable";
          address = [ "192.168.2.224/24" ];
          gateway = [ "192.168.2.1" ];
          networkConfig =
            let
              inherit (lib) boolToYesNo;
            in
            {
              DNSSEC = boolToYesNo true;
              DNSOverTLS = boolToYesNo true;
            };
        };
      };
    };
}
