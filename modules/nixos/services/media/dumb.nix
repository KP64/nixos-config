{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.services.media.dumb;
  port = 5555;
  dumbPort = toString port;
in
{
  options.services.media.dumb.enable = lib.mkEnableOption "Dumb";

  config = lib.mkIf cfg.enable {
    services = {
      traefik.dynamicConfigOptions.http = {
        routers.dumb = {
          rule = "Host(`dumb.${config.networking.domain}`)";
          service = "dumb";
        };
        services.dumb.loadBalancer.servers = [ { url = "http://localhost:${dumbPort}"; } ];
      };

      tor.relay.onionServices.dumb.map = [
        {
          port = 80;
          target = {
            addr = "127.0.0.1";
            inherit port;
          };
        }
      ];

      i2pd.inTunnels.dumb = {
        enable = true;
        destination = "127.0.0.1";
        inherit port;
      };
    };

    systemd.services.dumb = {
      description = "Private alternative front-end for Genius";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = lib.getExe inputs.self.packages.${pkgs.system}.dumb;
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
