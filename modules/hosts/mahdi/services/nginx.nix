{
  # TODO: From Reverse Proxy to Service should preferably be HTTPS too!
  # TODO: Add more/missing Security headers
  # TODO: Disable caching from OAauth endpoints!
  flake.modules.nixos.hosts-mahdi =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      networking.firewall =
        let
          ssl = lib.optional config.services.nginx.enable config.services.nginx.defaultSSLListenPort;
        in
        {
          allowedTCPPorts = ssl;
          # QUIC uses UDP
          allowedUDPPorts = ssl;
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
