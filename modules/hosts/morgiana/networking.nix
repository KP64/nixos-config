{ den, ... }: {
  den.aspects.morgiana = {
    includes = with den.aspects; [
      static-ip
      wifi
    ];

    nixos =
      let
        addr = "212";
      in
      {
        networking.domain = "srvd.space";

        systemd.network.networks."10-wlan0" = {
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
}
