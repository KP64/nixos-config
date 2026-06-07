toplevel@{ den, ... }:
{
  den.aspects.aladdin = {
    includes = with den.aspects.networking._; [
      ip
      wifi
    ];

    nixos =
      { config, lib, ... }:
      let
        zarqaCfg = toplevel.config.flake.nixosConfigurations.zarqa.config;
      in
      {
        networking = {
          inherit (zarqaCfg.networking) domain;
          # Let systemd configure everything
          useDHCP = false;
          dhcpcd.enable = false;
        };

        staticIPv4 = "192.168.2.221";
        staticIPv6 = "fdef:fa6a:4724:1::221";

        systemd.network = {
          enable = true;
          networks."10-wlp6s0" = {
            name = "wlp6s0";
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
