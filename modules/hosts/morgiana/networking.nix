toplevel@{ den, ... }:
{
  den.aspects.morgiana = {
    includes = with den.aspects.networking._; [
      ip
      wifi
    ];

    nixos = { config, lib, ... }: {
      networking = {
        inherit (toplevel.config.flake.nixosConfigurations.zarqa.config.networking) domain;
        useDHCP = false;
        dhcpcd.enable = false;
      };

      staticIPv4 = "192.168.2.212";
      staticIPv6 = "fdef:fa6a:4724:1::212";

      systemd.network = {
        enable = true;
        networks."10-wlan0" = {
          name = "wlan0";
          address = [
            "${config.staticIPv4}/24"
            "${config.staticIPv6}/64"
          ];
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
  };
}
