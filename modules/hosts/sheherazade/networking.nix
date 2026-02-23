toplevel: {
  flake.modules.nixos.hosts-sheherazade =
    { config, lib, ... }:
    {
      imports = [ toplevel.config.flake.modules.nixos.ip ];

      sops.secrets."wireless.env".owner = config.users.users.wpa_supplicant.name;

      networking = {
        inherit (toplevel.config.flake.nixosConfigurations.zarqa.config.networking) domain;
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

      # We don't care which interface is online here
      systemd.network.wait-online.anyInterface = true;
      boot.initrd.systemd.network.wait-online.anyInterface = true;

      staticIPv4 = "192.168.2.224";

      systemd.network = {
        enable = true;
        networks."10-wlan0" = {
          name = "wlan0";
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
