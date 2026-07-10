toplevel@{ den, ... }:
{
  den.aspects.aladdin = {
    includes = with den.aspects.networking._; [
      ip
      wifi
    ];

    nixos =
      { config, ... }:
      let
        addr = "221";
      in
      {
        networking = {
          inherit (toplevel.config.flake.nixosConfigurations.zarqa.config.networking) domain;
          # Let systemd configure everything
          useDHCP = false;
          dhcpcd.enable = false;
        };

        staticIPv6 = "${config.lib.topology.getHomeCidr}::${addr}";

        systemd.network = {
          enable = true;
          networks."10-wlp6s0" = {
            name = "wlp6s0";
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
              DNSOverTLS = true;
              DNSSEC = true;
              LLMNR = false;
              MulticastDNS = true;
            };
            ipv6AcceptRAConfig.Token = "static:::${addr}";
          };
        };
      };
  };
}
