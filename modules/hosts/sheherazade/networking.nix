{ den, ... }: {
  den.aspects.sheherazade = {
    includes = with den.aspects; [
      static-ip
      wifi
    ];

    nixos =
      { host, ... }:
      let
        addr = "224";
      in
      {
        # TODO: Replace
        networking.domain = "srvd.space";

        systemd.network.networks."10-end0" = {
          name = "end0";
          address = [ "${host.settings.static-ip.v4}/24" ];
          # TODO: Set
          # gateway = [ "${config.lib.topology.getHomeCidr4}.1" ];
          networkConfig = {
            IPv6AcceptRA = true;
            IPv6PrivacyExtensions = false;
          };
          ipv6AcceptRAConfig.Token = "static:::${addr}";
        };
      };
  };
}
