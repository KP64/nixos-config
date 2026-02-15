{
  # TODO: From Reverse Proxy to Service should preferably be HTTPS too!
  # TODO: Add more/missing Security headers
  # TODO: Disable caching from OAauth endpoints!
  flake.aspects.hosts-mahdi.nixos =
    { config, pkgs, ... }:
    {
      networking.firewall =
        let
          inherit (config.services.nginx) defaultSSLListenPort;
        in
        {
          allowedTCPPorts = [ defaultSSLListenPort ];
          # QUIC uses UDP
          allowedUDPPorts = [ defaultSSLListenPort ];
        };

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
