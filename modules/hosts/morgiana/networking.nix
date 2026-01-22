{
  flake.modules.nixos.hosts-morgiana =
    { config, lib, ... }:
    {
      sops.secrets."wireless.env".owner = config.users.users.wpa_supplicant.name;

      networking = {
        useDHCP = false;
        dhcpcd.enable = false;
        wireless = {
          enable = true;
          secretsFile = config.sops.secrets."wireless.env".path;
          fallbackToWPA2 = false;
          scanOnLowSignal = false;
          networks.Home-5GHz.pskRaw = "ext:HOME_WIFI_PASSWORD";
        };
      };

      systemd.network.wait-online.anyInterface = true;
      boot.initrd.systemd.network.wait-online.anyInterface = true;

      systemd.network = {
        enable = true;
        networks."10-wlan0" = {
          name = "wlan0";
          linkConfig.RequiredForOnline = "routable";
          address = [ "192.168.2.212/24" ];
          gateway = [ "192.168.2.1" ];
          dns =
            map (qdns: "${qdns}#dns.quad9.net") [
              "9.9.9.9"
              "149.112.112.112"
              "2620:fe::fe"
              "2620:fe::9"
            ]
            ++ map (cdns: "${cdns}#cloudflare-dns.com") [
              "1.1.1.1"
              "1.0.0.1"
              "2606:4700:4700::1111"
              "2606:4700:4700::1001"
            ];
          networkConfig = {
            DNSSEC = "allow-downgrade";
            DNSOverTLS = "opportunistic";
            MulticastDNS = lib.boolToYesNo true;
            LLMNR = lib.boolToYesNo false;
          };
        };
      };
    };
}
