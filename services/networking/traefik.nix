{ config, lib, ... }:
let
  cfg = config.services.networking.traefik;
in
# Due to non external factors traefik can't be used yet with authentik-nix.
# Therefore router Firewall is disabled by default.
# When done
# TODO: Authentik-nix
# TODO: Remove most if not all "openFirewall" instances in Config
# TODO: Replace SearXNG with selfhosted instance
{
  options = {
    homelab.domain = lib.mkOption {
      default = "nix-pi.ipv64.de";
      type = lib.types.nonEmptyStr;
      example = "myHomeLab.de";
      description = "The Domain which exposes all Services";
    };

    services.networking.traefik.enable = lib.mkEnableOption "Traefik";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];

      services.traefik = {
        enable = true;

        dynamicConfigOptions.http.routers.dashboard = {
          rule = "Host(`traefik.${config.homelab.domain}`)";
          service = "api@internal";
        };

        staticConfigOptions = {
          global = {
            checkNewVersion = false;
            sendAnonymousUsage = false;
          };

          api = {
            disableDashboardAd = true;
            insecure = true; # TODO: Revert when using HTTPS
          };

          log = {
            level = "INFO";
            filePath = "${config.services.traefik.dataDir}/traefik.log";
            format = "json";
          };

          entryPoints = {
            web = {
              address = ":80";
              # http.redirections.entryPoint = {
              #   to = "websecure";
              #   scheme = "https";
              #   permanent = true;
              # };
            };
            websecure = {
              address = ":443";
              # http.tls = {
              #   certResolver = "letsencrypt";
              #   domains = [ ];
              # };
            };
          };
        };
      };
    })

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".directories =
        lib.optional cfg.enable config.services.traefik.dataDir;
    })
  ];
}
