toplevel@{ den, ... }:
{
  den.aspects.mahdi = {
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
          useDHCP = false;
          dhcpcd.enable = false;
        };

        staticIPv4 = "192.168.178.220";
        staticIPv6 = "fd57:36cf:1d6b:0::220";

        systemd.network = {
          enable = true;
          networks."10-wlp130s0f0" = {
            name = "wlp130s0f0";
            address = [
              "${config.staticIPv4}/24"
              "${config.staticIPv6}/64"
            ];
            gateway = [ "192.168.178.1" ];
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
