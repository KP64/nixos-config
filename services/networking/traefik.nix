{ config, lib, ... }:
let
  cfg = config.services.networking.traefik;
in
# TODO: Authentik-nix
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
