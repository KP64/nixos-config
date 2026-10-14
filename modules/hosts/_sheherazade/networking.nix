{ den, ... }: {
  den.aspects.sheherazade = {
    includes = with den.aspects; [
      static-ip
      wifi
    ];

    nixos =
      { config, ... }:
      let
        addr = "224";
      in
      {
        networking.domain = "srvd.space";

        staticIPv4 = "${config.lib.topology.getHomeCidr4}.${addr}";
        staticIPv6 = "${config.lib.topology.getHomeCidr6}::${addr}";

        systemd.network.networks."10-end0" = {
          name = "end0";
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
}
