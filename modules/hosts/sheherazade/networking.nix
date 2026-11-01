{ den, ... }: {
  den.aspects.sheherazade = {
    includes = [ den.aspects.wifi ];

    nixos =
      let
        addr = "224";
      in
      {
        systemd.network.networks."10-end0" = {
          name = "end0";
          networkConfig = {
            IPv6AcceptRA = true;
            IPv6PrivacyExtensions = false;
          };
          ipv6AcceptRAConfig.Token = "static:::${addr}";
        };
      };
  };
}
