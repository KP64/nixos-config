{
  flake.modules.nixos.hosts-mahdi =
    { config, pkgs, ... }:
    let
      port = 45467;
    in
    {
      services.nginx.virtualHosts."coder.${config.networking.domain}" = {
        enableACME = true;
        acmeRoot = null;
        onlySSL = true;
        kTLS = true;
        locations."/" = {
          proxyWebsockets = true;
          proxyPass = "http://localhost:${toString port}";
        };
      };

      virtualisation.docker = {
        enable = true;
        rootless = {
          enable = true;
          setSocketVariable = true;
        };
        autoPrune.enable = true;
      };

      # Doesn't have permission to access the socket otherway
      users.users.coder.extraGroups = [ "docker" ];

      services.coder = {
        enable = true;
        package = pkgs.coder.override { channel = "mainline"; };
        accessUrl = "https://coder.${config.networking.domain}";
        wildcardAccessUrl = "*.coder.${config.networking.domain}";
        listenAddress = "127.0.0.1:${toString port}";
        environment.extra = {
          CODER_BLOCK_DIRECT = "1";
          CODER_DISABLE_PASSWORD_AUTH = "1";
          CODER_DISABLE_SESSION_EXPIRY_REFRESH = "1";
          CODER_SECURE_AUTH_COOKIE = "1";
          CODER_STRICT_TRANSPORT_SECURITY = "31536000";
        };
      };
    };
}
