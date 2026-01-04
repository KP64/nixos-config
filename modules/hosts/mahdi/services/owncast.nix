{
  flake.modules.nixos.hosts-mahdi =
    { config, pkgs, ... }:
    let
      reverseRTMPPort = 1935;
    in
    {
      networking.firewall.allowedTCPPorts = [ reverseRTMPPort ];

      services.nginx = {
        additionalModules = [ pkgs.nginxModules.rtmp ];

        virtualHosts."owncast.${config.networking.domain}" = {
          enableACME = true;
          acmeRoot = null;
          onlySSL = true;
          kTLS = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.owncast.port}";
          };
        };

        appendConfig = ''
          rtmp {
            server {
              listen ${toString reverseRTMPPort};
              application owncast {
                live on;
                record off;
                push rtmp://127.0.0.1:${toString config.services.owncast.rtmp-port}/live;
              }
            }
          }
        '';
      };

      # NOTE: Default credentials are:
      #       username: admin
      #       password: abc123
      services.owncast = {
        enable = true;
        port = 32857;
        rtmp-port = 1936;
      };
    };
}
