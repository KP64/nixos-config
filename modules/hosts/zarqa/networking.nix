{ den, ... }: {
  den.aspects.zarqa = {
    includes = [ den.aspects.networking._.ip ];

    nixos =
      { config, ... }:
      let
        addr = "201";
      in
      {
        networking = {
          domain = "srvd.space";
          useDHCP = false;
          dhcpcd.enable = false;
        };

        staticIPv6 = "${config.lib.topology.getHomeCidr6}::${addr}";

        systemd.network = {
          enable = true;
          networks."10-enu1u1u1" = {
            name = "enu1u1u1";
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
