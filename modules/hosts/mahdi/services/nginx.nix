{
  # TODO: From Reverse Proxy to Service should preferably be HTTPS too!
  # TODO: Add more/missing Security headers
  # TODO: Disable caching from OAauth endpoints!
  flake.modules.nixos.hosts-mahdi =
    { pkgs, ... }:
    {
      networking.firewall.allowedTCPPorts = [ 443 ];

      # TODO: Enable ECH. DNS HTTPS Resource is prerequisite though.
      # NOTE: Amazing Websites:
      #  - https://securityheaders.com/
      #  - https://www.ssllabs.com/
      services.nginx = {
        enable = true;

        package = pkgs.nginxMainline;
        enableQuicBPF = true;

        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        recommendedUwsgiSettings = true;
        recommendedBrotliSettings = true;
      };
    };
}
