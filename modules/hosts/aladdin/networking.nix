toplevel: {
  flake.modules.nixos.hosts-aladdin =
    { config, lib, ... }:
    {
      imports = [ toplevel.config.flake.modules.nixos.ip ];

      sops.secrets."wireless.env".owner = config.users.users.wpa_supplicant.name;

      networking = {
        # Let systemd configure everything
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

      staticIPv4 = "192.168.2.221";

      systemd.network = {
        enable = true;
        networks."10-wlp6s0" = {
          name = "wlp6s0";
          address = [ "${config.staticIPv4}/24" ];
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
          networkConfig =
            let
              inherit (lib) boolToYesNo;
            in
            {
              DNSSEC = boolToYesNo true;
              DNSOverTLS = boolToYesNo true;
              MulticastDNS = boolToYesNo true;
              LLMNR = boolToYesNo false;
            };
        };
      };
    };
}
