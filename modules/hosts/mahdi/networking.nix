{
  flake.modules.nixos.hosts-mahdi =
    { config, lib, ... }:
    {
      sops.secrets."wireless.env".owner = config.users.users.wpa_supplicant.name;

      networking = {
        domain = "holab.ipv64.de";
        useNetworkd = true; # Needed so that there aren't two IPv4/6 Addresses.
        useDHCP = false; # Let systemd configure everything
        wireless = {
          enable = true;
          secretsFile = config.sops.secrets."wireless.env".path;
          fallbackToWPA2 = false;
          scanOnLowSignal = false;
          networks.Home-5GHz.pskRaw = "ext:HOME_WIFI_PASSWORD";
        };
      };

      services.resolved = {
        enable = true;
        dnssec = "true";
        dnsovertls = "true";
        fallbackDns = [ ]; # No fallbacks
      };

      # We don't care which interface is online here
      systemd.network.wait-online.anyInterface = true;
      boot.initrd.systemd.network.wait-online.anyInterface = true;

      systemd.network = {
        enable = true;
        networks."10-wlp130s0f0" = {
          name = "wlp130s0f0";
          linkConfig.RequiredForOnline = "routable";
          address = [ "192.168.2.220/24" ];
          gateway = [ "192.168.2.1" ];
          dns =
            map (qdns: "${qdns}#dns.quad9.net") [
              "9.9.9.9"
              "149.112.112.112"
              "2620:fe::fe"
              "2620:fe::9"
            ]
            ++ map (cdns: "${cdns}#cloudflare-dns.com") [
              "1.1.1.1"
              "1.0.0.1"
              "2606:4700:4700::1111"
              "2606:4700:4700::1001"
            ];
          networkConfig =
            let
              inherit (lib) boolToYesNo;
            in
            {
              DNSSEC = boolToYesNo true;
              DNSOverTLS = boolToYesNo true;
              IPv6PrivacyExtensions = boolToYesNo true;
            };
        };
      };
    };
}
