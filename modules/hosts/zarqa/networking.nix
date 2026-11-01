{ den, ... }: {
  den.aspects.zarqa = {
    includes = [ den.aspects.wifi ];

    nixos =
      let
        addr = "201";
      in
      {
        systemd.network.networks."10-wlan0" = {
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
}
