{
  den.aspects.morgiana.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    lib.mkMerge [
      (lib.mkIf config.services.firefox-syncserver.enable {
        sops = {
          secrets = {
            "firefox-sync/master" = { };
            "firefox-sync/metrics" = { };
          };
          templates."firefox-syncserver.env" = {
            restartUnits = [ config.systemd.services.firefox-syncserver.name ];
            content = ''
              SYNC_MASTER_SECRET=${config.sops.placeholder."firefox-sync/master"}
              SYNC_TOKENSERVER__FXA_METRICS_HASH_SECRET=${config.sops.placeholder."firefox-sync/metrics"}
            '';
          };
        };
        services = {
          mysql.package = pkgs.mariadb;

          caddy.virtualHosts.${config.services.firefox-syncserver.singleNode.hostname}.extraConfig = # caddy
            ''
              reverse_proxy http://127.0.0.1:${toString config.services.firefox-syncserver.settings.port}
            '';
        };
      })
      {
        services.firefox-syncserver = {
          enable = true;
          secrets = config.sops.templates."firefox-syncserver.env".path;
          singleNode = {
            enable = true;
            hostname = "firefox-sync.${config.networking.domain}";
            enableTLS = true;
          };
        };
      }
    ];
}
