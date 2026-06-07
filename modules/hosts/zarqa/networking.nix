{ den, ... }: {
  den.aspects.zarqa = {
    includes = [ den.aspects.ip ];

    nixos = { config, ... }: {
      networking = {
        domain = "srvd.space";
        useDHCP = false;
        dhcpcd.enable = false;
      };

      staticIPv4 = "192.168.2.201";
      staticIPv6 = "fdef:fa6a:4724:1::201";

      systemd.network = {
        enable = true;
        networks."10-enu1u1u1" = {
          name = "enu1u1u1";
          address = [
            "${config.staticIPv4}/24"
            "${config.staticIPv6}/64"
          ];
          gateway = [ "192.168.2.1" ];
        };
      };
    };
  };
}
