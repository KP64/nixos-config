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

        staticIPv4 = "${config.lib.topology.getHomeCidr4}.${addr}";
        staticIPv6 = "${config.lib.topology.getHomeCidr6}::${addr}";

        systemd.network = {
          enable = true;
          networks."10-enu1u1u1" = {
            name = "enu1u1u1";
            address = [ "${config.staticIPv4}/24" ];
            gateway = [ "${config.lib.topology.getHomeCidr4}.1" ];
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
