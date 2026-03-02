toplevel@{ moduleWithSystem, ... }:
{
  flake.modules.nixos.anonymousoverflow = moduleWithSystem (
    { config, ... }:
    nixos@{ lib, ... }:
    let
      cfg = nixos.config.services.anonymousoverflow;
    in
    {
      options.services.anonymousoverflow = {
        enable = lib.mkEnableOption "anonymousoverflow";
        package = lib.mkPackageOption config.packages "anonymousoverflow" { };
        host = lib.mkOption {
          type = with lib.types; nullOr nonEmptyStr;
          default = "127.0.0.1";
          example = "0.0.0.0";
          description = "Where it should listen.";
        };
        port = lib.mkOption {
          type = lib.types.port;
          default = 5768;
          example = 8080;
          description = "The port that Anonymousoverflow will listen on.";
        };
        openFirewall = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Whether to open the Anonymousoverflow port in the firewall.";
        };
        appUrl = lib.mkOption {
          type = lib.types.nonEmptyStr;
          default = "http://localhost";
          example = "https://overflow.example.com";
        };
        environmentFile = lib.mkOption {
          type = lib.types.path;
          description = ''
            Path to the file containing the JWT_SIGNING_SECRET variable.
            To generate the variable run `openssl rand -base64 32`.
          '';
        };
      };

      config = lib.mkIf cfg.enable {
        topology = lib.mkIf (nixos.config ? topology) {
          self.services.anonymousoverflow = {
            name = "Anonymousoverflow";
            icon = toplevel.config.lib.flake.util.getIcon {
              file = "anonymousoverflow.svg";
              type = "icons";
            };
            details.listen = lib.mkIf cfg.openFirewall {
              text = "http://${cfg.host}:${toString cfg.port}";
            };
          };
        };

        networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.port;

        systemd.services.anonymousoverflow = {
          description = "View StackOverflow in privacy and without the clutter.";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          enableStrictShellChecks = true;

          environment = {
            HOST = cfg.host;
            PORT = toString cfg.port;
            APP_URL = cfg.appUrl;
          };

          serviceConfig = {
            EnvironmentFile = cfg.environmentFile;
            ExecStart = lib.getExe cfg.package;
            DynamicUser = true;
            UMask = "0077";
            RemoveIPC = true;
            LockPersonality = true;
            NoNewPrivileges = true;
            MemoryDenyWriteExecute = true;

            CapabilityBoundingSet = "";
            SystemCallArchitectures = "native";
            SystemCallFilter = [ "~ @privileged @resources @debug @obsolete @cpu-emulation @mount" ];

            RestrictSUIDSGID = true;
            RestrictRealtime = true;
            RestrictNamespaces = true;
            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
            ];
            PrivateDevices = true;
            PrivateUsers = true;
            PrivateTmp = true;
            ProcSubset = "pid";
            ProtectProc = "invisible";
            ProtectSystem = "strict";
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectHome = true;
            ProtectClock = true;
            ProtectKernelLogs = true;
            ProtectControlGroups = true;
            ProtectHostname = true;
          };
        };
      };
    }
  );
}
