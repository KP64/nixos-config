{
  flake.modules.nixos.hosts-mahdi =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    lib.mkMerge [
      (lib.mkIf config.services.firefox-syncserver.enable {
        sops.secrets."firefox-syncserver.env" = { };
        services = {
          mysql.package = pkgs.mariadb;

          nginx.virtualHosts.${config.services.firefox-syncserver.singleNode.hostname} =
            lib.mkIf config.services.firefox-syncserver.singleNode.enableNginx
              {
                forceSSL = lib.mkForce false;
                onlySSL = true;
                acmeRoot = null;
                kTLS = true;
              };
        };
      })
      {
        services.firefox-syncserver = {
          enable = true;
          secrets = config.sops.secrets."firefox-syncserver.env".path;
          singleNode = {
            enable = true;
            hostname = "firefox-sync.${config.networking.domain}";
            enableTLS = true;
            enableNginx = true;
          };
        };
      }
    ];
}
