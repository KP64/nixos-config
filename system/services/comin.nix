{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.system.services.comin;
in
{
  imports = [ inputs.comin.nixosModules.comin ];

  options.system.services.comin.enable = lib.mkEnableOption "Comin" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    services.comin = {
      enable = true;
      remotes = [
        {
          name = "origin";
          url = "https://github.com/KP64/nixos-config.git";
          poller.period = 60 * 5; # 5 min
          # No testing branch on this remote
          branches.testing.name = "";
        }
      ];
      # exporter = { }; # TODO: For prometheus
    };

    systemd.services.comin.serviceConfig = {
      DynamicUser = true;
      UMask = "0077";

      RemoveIPC = true;
      LockPersonality = true;
      NoNewPrivileges = true;
      MemoryDenyWriteExecute = true;
      CapabilityBoundingSet = "";

      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "~ @privileged @resources @debug @obsolete @cpu-emulation @mount"
      ];

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
}
