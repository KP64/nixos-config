{
  den.aspects.aladdin.nixos = {
    systemd.network.networks."10-wlp7s0" = {
      name = "wlp7s0";
      DHCP = "ipv4";
      networkConfig = {
        IPv6AcceptRA = true;
        DNSSEC = true;
        LLMNR = false;
        MulticastDNS = true;
      };
    };
  };
}
