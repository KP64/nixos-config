{
  den.aspects.trippy = {
    nixos.programs.trippy.enable = true;

    homeManager.programs.trippy = {
      enable = true;
      settings = {
        dns.dns-resolve-all = true;
        strategy = {
          addr-family = "ipv6-then-ipv4";
          icmp-extensions = true;
        };
        trippy.log-span-events = "full";
        tui = {
          tui-address-mode = "both";
          tui-as-mode = "asn";
          tui-custom-columns = "holsravbwdt";
          tui-icmp-extension-mode = "all";
        };
      };
    };
  };
}
