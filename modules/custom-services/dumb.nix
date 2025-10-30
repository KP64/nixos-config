{ moduleWithSystem, ... }:
{
  flake.nixosModules.dumb = moduleWithSystem (
    { config, ... }:
    nixos@{ lib, ... }:
    let
      cfg = nixos.config.services.dumb;
    in
    {
      options.services.dumb = {
        enable = lib.mkEnableOption "Dumb";
        package = lib.mkPackageOption config.packages "dumb" { };
        port = lib.mkOption {
          type = lib.types.port;
          default = 5555;
          description = "The port that dumb will listen on.";
        };
        openFirewall = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to open the dumb port in the firewall.";
        };
      };

      config = lib.mkIf cfg.enable {
        networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.port;

        systemd.services.dumb = {
          description = "Private alternative front-end for Genius";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          enableStrictShellChecks = true;

          environment.PORT = toString cfg.port;

          serviceConfig = {
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
