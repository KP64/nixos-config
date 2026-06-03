{ den, ... }: {
  den.aspects.zarqa = {
    includes = with den.aspects; [
      ip
      wifi
    ];

    nixos = { config, ... }: {
      networking = {
        domain = "srvd.space";
        useDHCP = false;
        dhcpcd.enable = false;
      };

      # We don't care which interface is online here
      systemd.network.wait-online.anyInterface = true;
      boot.initrd.systemd.network.wait-online.anyInterface = true;

      staticIPv4 = "192.168.2.201";
      staticIPv6 = "fdef:fa6a:4724:1::201";

      systemd.network = {
        enable = true;
        networks."10-wlan0" = {
          name = "wlan0";
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
