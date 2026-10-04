toplevel@{ den, ... }:
{
  den.aspects.aladdin = {
    includes = with den.aspects.networking._; [
      ip
      wifi
    ];

    nixos =
      { config, ... }:
      let
        addr = "221";
      in
      {
        networking = {
          inherit (toplevel.config.flake.nixosConfigurations.sheherazade.config.networking) domain;
        };

        staticIPv6 = "${config.lib.topology.getHomeCidr6}::${addr}";

        systemd.network.networks."10-wlp7s0" = {
          name = "wlp7s0";
          DHCP = "ipv4";
          networkConfig = {
            IPv6AcceptRA = true;
            DNSSEC = true;
            LLMNR = false;
            MulticastDNS = true;
          };
          ipv6AcceptRAConfig.Token = "static:::${addr}";
        };
      };
  };
}
