{ den, ... }: {
  den.aspects.mahdi = {
    includes = [ den.aspects.static-ip ];
    # TODO: Get correct addr
    settings.static-ip.v6 = "bogus";
    # staticIPv6 = "${config.lib.topology.getHomeCidr6}::${addr}";

    nixos =
      let
        addr = "220";
      in
      {
        # TODO: Replace
        networking.domain = "srvd.space";

        systemd.network.networks."10-wlp130s0f0" = {
          name = "wlp130s0f0";
          DHCP = "ipv4";
          networkConfig = {
            IPv6AcceptRA = true;
            IPv6PrivacyExtensions = false;
            DNSSEC = true;
            LLMNR = false;
            MulticastDNS = true;
          };
          ipv6AcceptRAConfig.Token = [ "static:::${addr}" ];
        };
      };
  };
}
