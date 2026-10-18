{ den, ... }: {
  den.aspects.aladdin = {
    includes = [ den.aspects.wifi ];
    nixos = {
      systemd.network.networks."10-wlp7s0" = {
        name = "wlp7s0";
        DHCP = "ipv4";
        networkConfig = {
          DNSSEC = true;
          LLMNR = false;
          MulticastDNS = true;

          IPv6AcceptRA = true;
          IPv6PrivacyExtensions = true;
        };
      };
    };
  };
}
