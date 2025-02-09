{
  self,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.media.neuters;
  port = 13369;
in
{
  options.services.media.neuters.enable = lib.mkEnableOption "Neuters";

  config = lib.mkIf cfg.enable {
    services = {
      traefik.dynamicConfigOptions.http = {
        routers.neuters = {
          rule = "Host(`neuters.${config.networking.domain}`)";
          service = "neuters";
        };
        services.neuters.loadBalancer.servers = [ { url = "http://localhost:${toString port}"; } ];
      };

      tor.relay.onionServices.neuters.map = [
        {
          port = 80;
          target = {
            addr = "127.0.0.1";
            inherit port;
          };
        }
      ];

      i2pd.inTunnels.neuters = {
        enable = true;
        destination = "127.0.0.1";
        inherit port;
      };
    };

    systemd.services.neuters = {
      description = "Reuters Redirect and Proxy.";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = lib.getExe self.packages.${pkgs.system}.neuters;
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
