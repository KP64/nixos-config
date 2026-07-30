toplevel@{ den, ... }:
{
  den.aspects.sheherazade = {
    includes = with den.aspects.networking._; [
      ip
      wifi
    ];

    nixos =
      { config, ... }:
      let
        addr = "224";
      in
      {
        networking = {
          inherit (toplevel.config.flake.nixosConfigurations.zarqa.config.networking) domain;
          useDHCP = false;
          dhcpcd.enable = false;
        };

        staticIPv6 = "${config.lib.topology.getHomeCidr6}::${addr}";

        systemd.network = {
          enable = true;
          networks."10-wlan0" = {
            name = "wlan0";
            DHCP = "ipv4";
            networkConfig = {
              IPv6AcceptRA = true;
              IPv6PrivacyExtensions = false;
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
