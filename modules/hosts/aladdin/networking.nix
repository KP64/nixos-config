toplevel: {
  flake.modules.nixos.hosts-aladdin =
    { config, lib, ... }:
    let
      zarqaCfg = toplevel.config.flake.nixosConfigurations.zarqa.config;
    in
    {
      imports = [ toplevel.config.flake.modules.nixos.ip ];

      sops.secrets."wireless.env".owner = config.users.users.wpa_supplicant.name;

      networking = {
        inherit (zarqaCfg.networking) domain;
        # Let systemd configure everything
        useDHCP = false;
        dhcpcd.enable = false;

        wireless = {
          enable = true;
          secretsFile = config.sops.secrets."wireless.env".path;
          fallbackToWPA2 = false;
          scanOnLowSignal = false;
          networks.Home-5GHz.pskRaw = "ext:HOME_WIFI_PASSWORD";
        };
      };

      staticIPv4 = "192.168.2.221";
      staticIPv6 = "fdef:fa6a:4724:1::221";

      systemd.network = {
        enable = true;
        networks."10-wlp6s0" = {
          name = "wlp6s0";
          address = [
            "${config.staticIPv4}/24"
            "${config.staticIPv6}/64"
          ];
          gateway = [ "192.168.2.1" ];
          dns = [ "192.168.2.1" ];
          networkConfig =
            let
              inherit (lib) boolToYesNo;
            in
            {
              DNSSEC = "allow-downgrade";
              DNSOverTLS = "opportunistic";
              # TODO: Reenforce when I figure Hickory DNS out.
              # DNSSEC = boolToYesNo true;
              # DNSOverTLS = boolToYesNo true;
              MulticastDNS = boolToYesNo true;
              LLMNR = boolToYesNo false;
            };
        };
      };
    };
}
