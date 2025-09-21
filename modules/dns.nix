{
  flake.modules.nixos.dns = {
    # In quad9 and cloudflare we trust...
    networking.nameservers =
      map (qdns: "${qdns}#dns.quad9.net") [
        "9.9.9.9"
        "2620:fe::9"
      ]
      ++ map (cdns: "${cdns}#cloudflare-dns.com") [
        "1.1.1.1"
        "2606:4700:4700::1111"
      ];

    # NOTE: Replace resolved? Reference https://wiki.nixos.org/wiki/Encrypted_DNS
    services.resolved = {
      enable = true;
      dnssec = "true";
      dnsovertls = "true";
      fallbackDns = [ ]; # No fallbacks
    };
  };
}
