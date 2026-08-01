{ den, ... }: {
  den.aspects.sheherazade = {
    includes = [ den.aspects.networking._.ip ];

    nixos =
      { config, ... }:
      let
        addr = "224";
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
          networks."10-end0" = {
            name = "end0";
            address = [ "${config.staticIPv4}/24" ];
            gateway = [ "${config.lib.topology.getHomeCidr4}.1" ];
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
