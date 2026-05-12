toplevel@{ den, ... }:
{
  den.aspects.morgiana = {
    includes = [ den.aspects.ip ];
    nixos =
      { config, lib, ... }:
      let
        zarqaCfg = toplevel.config.flake.nixosConfigurations.zarqa.config;
      in
      {
        sops.secrets."wireless.env".owner = config.users.users.wpa_supplicant.name;

        networking = {
          inherit (toplevel.config.flake.nixosConfigurations.zarqa.config.networking) domain;
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

        systemd.network.wait-online.anyInterface = true;
        boot.initrd.systemd.network.wait-online.anyInterface = true;

        staticIPv4 = "192.168.2.212";
        staticIPv6 = "fdef:fa6a:4724:1::212";

        services.resolved.dnsDelegates.homelab.Delegate = {
          DNS = with zarqaCfg; [
            staticIPv4
            staticIPv6
          ];
          Domains = [ config.networking.domain ];
        };

        systemd.network = {
          enable = true;
          networks."10-wlan0" = {
            name = "wlan0";
            address = [
              "${config.staticIPv4}/24"
              "${config.staticIPv6}/64"
            ];
            gateway = [ "192.168.2.1" ];
            dns = [ "192.168.2.1" ];
            networkConfig = {
              DNSSEC = "allow-downgrade";
              DNSOverTLS = "opportunistic";
              MulticastDNS = lib.boolToYesNo true;
              LLMNR = lib.boolToYesNo false;
            };
          };
        };
      };
  };
}
