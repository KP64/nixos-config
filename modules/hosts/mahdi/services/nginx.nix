{
  den.aspects.mahdi.nixos =
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

      # TODO: Enable ECH. DNS HTTPS Resource is prerequisite though.
      # NOTE: Amazing Websites:
      #  - https://securityheaders.com/
      #  - https://www.ssllabs.com/
      services.nginx = {
        enable = true;

        defaultListenAddresses = [
          config.staticIPv4
        ]
        ++ lib.optional config.networking.enableIPv6 "[${config.staticIPv6}]";

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
