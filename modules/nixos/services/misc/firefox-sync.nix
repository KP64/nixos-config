{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.misc.firefox-sync;
in
{
  options.services.misc.firefox-sync.enable = lib.mkEnableOption "Firefox Sync";

  config.services = lib.mkIf cfg.enable {
    traefik.dynamicConfigOptions.http = {
      routers.firefox-sync = {
        rule = "Host(`firefox-sync.${config.networking.domain}`)";
        service = "firefox-sync";
      };
      services.firefox-sync.loadBalancer.servers = [
        { url = "http://localhost:${toString config.services.firefox-syncserver.settings.port}"; }
      ];
    };

    mysql.package = pkgs.mariadb;
    firefox-syncserver = {
      enable = true;
      secrets = config.sops.secrets."firefox_sync.env".path;
      singleNode = {
        enable = true;
        hostname = "firefox-sync.${config.networking.domain}";
      };
    };
  };
}
