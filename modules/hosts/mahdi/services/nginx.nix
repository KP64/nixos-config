{ den, ... }: {
  den.aspects.mahdi = {
    includes = [ den.aspects.acme ];

    nixos =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        networking.firewall =
          let
            ssl = [ config.services.nginx.defaultSSLListenPort ];
          in
          lib.mkIf config.services.nginx.enable {
            allowedTCPPorts = ssl;
            # QUIC uses UDP
            allowedUDPPorts = ssl;
          };

        # TODO: Replace with Caddy for uniformity
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
  };
}
