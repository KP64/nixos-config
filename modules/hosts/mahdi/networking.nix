{ den, ... }: {
  den.aspects.mahdi = {
    includes = with den.aspects; [
      static-ip
      wifi
    ];

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
