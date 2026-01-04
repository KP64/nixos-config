{
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    {
      services.nginx.virtualHosts."code-server.${config.networking.domain}" = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        locations."/" = {
          proxyWebsockets = true;
          proxyPass = "http://127.0.0.1:${toString config.services.code-server.port}";
        };
      };

      services.code-server = {
        enable = true;
        disableTelemetry = true;
        disableUpdateCheck = true;
        hashedPassword = "$argon2i$v=19$m=4096,t=3,p=1$SzRETTV4Z0VxUDF3WU5Pa2d1UmxOaEZxNkpJPQ$inoHfYan+i8IHSK4Dv0l7NtEGZr7HDrsysCYOW3GN3U";
      };
    };
}
