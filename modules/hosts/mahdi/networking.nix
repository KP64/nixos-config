{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      sops.secrets."wireless.env" = { };

      networking = {
        domain = "holab.ipv64.de";
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

      services.resolved = {
        enable = true;
        dnssec = "true";
        dnsovertls = "true";
        fallbackDns = [ ]; # No fallbacks
      };

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
