toplevel@{ den, ... }:
{
  den.aspects.zarqa = {
    includes = with den.aspects.networking._; [
      ip
      wifi
    ];

    nixos =
      { config, ... }:
      let
        addr = "201";
      in
      {
        networking = {
          inherit (toplevel.config.flake.nixosConfigurations.sheherazade.config.networking) domain;
          useDHCP = false;
          dhcpcd.enable = false;
        };

        wifiSSID = "FRITZ!Box 4630 QX";

        staticIPv6 = "${config.lib.topology.getHomeCidr6}::${addr}";

        systemd.network = {
          enable = true;
          networks."10-wlan0" = {
            name = "wlan0";
            DHCP = "ipv4";
            networkConfig = {
              IPv6AcceptRA = true;
              IPv6PrivacyExtensions = false;
            };
            ipv6AcceptRAConfig.Token = "static:::${addr}";
          };
        };
      };
  };
}
