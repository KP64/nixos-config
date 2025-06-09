{ config, lib, ... }:
{
  networking = lib.mkIf (config ? wsl && !config.wsl.enable) {
    nameservers = [
      # Quad9
      "9.9.9.9"
      "2620:fe::fe"

      # Cloudflare
      "1.1.1.1"
      "2606:4700:4700::1111"
    ];
  };

  services.resolved = {
    dnssec = "true";
    dnsovertls = "true";
    domains = [ "~." ];
    fallbackDns = [
      # Quad9
      "149.112.112.112"
      "2620:fe::9"

      # Cloudflare
      "1.0.0.1"
      "2606:4700:4700::1001"
    ];
  };
}
