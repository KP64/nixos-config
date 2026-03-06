toplevel: {
  flake.modules.nixos.opengist =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.services.opengist;
    in
    {
      options.services.opengist = {
        enable = lib.mkEnableOption "Opengist";

        package = lib.mkPackageOption pkgs "opengist" { };

        openFirewall = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to open the dumb port in the firewall.";
        };

        environmentFile = lib.mkOption {
          type = with lib.types; nullOr path;
          default = null;
          description = ''
            Environment Variables passed to the Service without
            writing them to the Nix Store.
          '';
        };

        environment = lib.mkOption {
          default = { };
          type = lib.types.submodule {
            freeformType = with lib.types; attrsOf anything;
            options = {
              OG_HTTP_HOST = lib.mkOption {
                type = lib.types.nonEmptyStr;
                default = "/run/opengist/opengist.sock";
              };
              OG_HTTP_PORT = lib.mkOption {
                type = lib.types.port;
                default = 6157;
              };
            };
          };
          description = ''
            The environment variables to be passed in.
            For secrets use the environmentFile option.
          '';
        };
      };

      config = lib.mkIf cfg.enable {
        topology = lib.mkIf (config ? topology) {
          self.services.opengist = {
            name = "Opengist";
            icon = toplevel.config.lib.flake.util.getIcon {
              file = "opengist.svg";
              type = "icons";
            };
            details.listen = lib.mkIf cfg.openFirewall {
              text = "http://${cfg.environment.OG_HTTP_HOST}:${toString cfg.environment.OG_HTTP_PORT}";
            };
          };
        };

        networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall (
          with cfg.environment;
          [
            OG_HTTP_PORT
            OG_SSH_PORT
          ]
        );

        systemd.services.opengist = {
          description = "opengist Server";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          enableStrictShellChecks = true;

          path = [ pkgs.gitMinimal ];

          environment =
            (lib.mapAttrs (_: v: if (builtins.isInt v) then toString v else v) cfg.environment)
            // {
              OG_OPENGIST_HOME = "/var/lib/opengist";
              OG_SSH_KEYGEN_EXECUTABLE = lib.getExe' pkgs.openssh "ssh-keygen";
            };

          serviceConfig =
            (lib.optionalAttrs (cfg.environmentFile != null) { EnvironmentFile = cfg.environmentFile; })
            // {
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

              RuntimeDirectory = "opengist";
              RuntimeDirectoryMode = "0755";
              StateDirectory = "opengist";
              CacheDirectory = "opengist";
              LogsDirectory = "opengist";

              RestrictSUIDSGID = true;
              RestrictRealtime = true;
              RestrictNamespaces = true;
              RestrictAddressFamilies = [
                "AF_UNIX"
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
    };
}
