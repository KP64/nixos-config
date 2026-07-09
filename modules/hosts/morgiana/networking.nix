toplevel@{ den, ... }:
{
  den.aspects.morgiana = {
    includes = with den.aspects.networking._; [
      ip
      wifi
    ];

    nixos = {
      networking = {
        inherit (toplevel.config.flake.nixosConfigurations.zarqa.config.networking) domain;
        useDHCP = false;
        dhcpcd.enable = false;
        tempAddresses = "disabled";
      };

      # TODO: Revert to 5GHz once https://github.com/nvmd/nixos-raspberrypi/issues/87 is closed.
      #       Seems like the issue stems from the Pi's network card. This may never be resolved.
      wifiSSID = "FRITZ!Box 4630 QX";

      staticIPv6 = "fd34:683f:dc06:0::212";

      systemd.network = {
        enable = true;
        networks."10-wlan0" = {
          name = "wlan0";
          dns =
            map (qdns: "${qdns}#dns.quad9.net") [
              "9.9.9.9"
              "149.112.112.112"
              "2620:fe::fe"
              "2620:fe::9"
            ]
            ++ map (cdns: "${cdns}#one.one.one.one") [
              "1.1.1.1"
              "1.0.0.1"
              "2606:4700:4700::1111"
              "2606:4700:4700::1001"
            ];
          networkConfig = {
            DHCP = "ipv4";
            IPv6AcceptRA = true;
            IPv6PrivacyExtensions = false;
            DNSOverTLS = true;
            DNSSEC = true;
            LLMNR = false;
            MulticastDNS = true;
          };
          ipv6AcceptRAConfig.Token = "static:::212";
        };
      };
    };
  };
}
