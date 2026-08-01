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

        # TODO: Revert to 5GHz once https://github.com/nvmd/nixos-raspberrypi/issues/87 is closed.
        #       Seems like the issue stems from the Pi's network card. This may never be resolved.
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
