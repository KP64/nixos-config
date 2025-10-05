{
  flake.modules.nixos.hosts-aladdin =
    { config, ... }:
    {
      sops.secrets."wireless.env" = { };

      networking = {
        useNetworkd = true; # Needed so that there aren't two IPv4/6 Addresses.
        useDHCP = false; # Let systemd configure everything
        wireless = {
          enable = true;
          secretsFile = config.sops.secrets."wireless.env".path;
          fallbackToWPA2 = false;
          scanOnLowSignal = false;
          networks.Home-5GHz = {
            hidden = true;
            pskRaw = "ext:HOME_WIFI_PASSWORD";
          };
        };
      };

      # This is a Desktop first and foremost.
      # Networking really isn't required.
      systemd.network.wait-online.enable = false;
      boot.initrd.systemd.network.wait-online.enable = false;

      services.resolved = {
        enable = true;
        dnssec = "true";
        dnsovertls = "true";
        fallbackDns = [ ]; # No fallbacks
      };

      systemd.network = {
        enable = true;
        networks."10-wlp6s0" = {
          name = "wlp6s0";
          linkConfig.RequiredForOnline = "routable";
          address = [ "192.168.2.221/24" ];
          gateway = [ "192.168.2.1" ];
          dns =
            map (qdns: "${qdns}#dns.quad9.net") [
              "9.9.9.9"
              "2620:fe::9"
            ]
            ++ map (cdns: "${cdns}#cloudflare-dns.com") [
              "1.1.1.1"
              "2606:4700:4700::1111"
            ];
          networkConfig = {
            DNSSEC = "yes";
            DNSOverTLS = "yes";
            IPv6PrivacyExtensions = "yes";
          };
        };
      };
    };
}
