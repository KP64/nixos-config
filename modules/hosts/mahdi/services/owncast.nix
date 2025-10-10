{
  flake.modules.nixos.hosts-mahdi =
    { config, pkgs, ... }:
    let
      reverseRTMPPort = 1935;
    in
    {
      services.nginx.virtualHosts."owncast.${config.networking.domain}" = {
        useACMEHost = config.networking.domain;
        onlySSL = true;
        kTLS = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString config.services.owncast.port}";
        };
      };

      # TODO: DO NOT USE 2 Proxies lol. This should be handled entirely differently.
      #       1.) Either find a way with traefik (preferred)
      #       2.) Replace traefik with another Proxy like Nginx
      networking.firewall.allowedTCPPorts = [ reverseRTMPPort ];

      services.nginx = {
        additionalModules = [ pkgs.nginxModules.rtmp ];

        appendConfig = ''
          rtmp {
            server {
              listen ${toString reverseRTMPPort};
              chunk_size 4096;

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
