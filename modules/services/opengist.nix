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
      format = pkgs.formats.yaml { };
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

        settings = lib.mkOption {
          default = { };
          description = ''
            Defines the config.yml file to be passed in to the Service.
            For Secrets pass them in as Environment Variables in the
            environmentFile option!
          '';
          type = lib.types.submodule {
            freeformType = format.type;
            options = {
              opengist-home = lib.mkOption {
                type = lib.types.nonEmptyStr;
                default = "/var/lib/opengist";
                description = "StateDirectory of the service";
              };
              "http.host" = lib.mkOption {
                readOnly = true;
                type = lib.types.nonEmptyStr;
                default = "/run/opengist/opengist.sock";
                description = ''
                  The host on which the HTTP server should bind.
                  Use an IP address for network binding.
                  Use a path for Unix socket binding (e.g. /run/opengist.sock)
                '';
              };
              "http.port" = lib.mkOption {
                type = lib.types.port;
                default = 6157;
                description = "The port on which the HTTP server should listen";
              };
              "ssh.port" = lib.mkOption {
                type = with lib.types; nullOr port;
                default = 2222;
              };
            };
          };
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
              text = "http://${cfg.settings."http.host"}:${toString cfg.settings."http.port"}";
            };
          };
        };

        networking.firewall = lib.mkIf cfg.openFirewall {
          allowedTCPPorts = [
            cfg.settings."http.port"
          ]
          ++ lib.optional (cfg.settings."ssh.port" != null) cfg.settings."ssh.port";
        };

        users = {
          users.opengist = {
            group = config.users.groups.opengist.name;
            isSystemUser = true;
            home = cfg.settings.opengist-home;
          };
          groups.opengist = { };
        };

        systemd.services.opengist = {
          description = "opengist Server";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          enableStrictShellChecks = true;

          path = with pkgs; [
            git
            openssh
          ];

          serviceConfig =
            (lib.optionalAttrs (cfg.environmentFile != null) { EnvironmentFile = cfg.environmentFile; })
            // {
              ExecStart = "${lib.getExe cfg.package} --config ${format.generate "config.yml" cfg.settings}";
              User = config.users.users.opengist.name;
              Group = config.users.groups.opengist.name;
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
              StateDirectory = baseNameOf cfg.settings.opengist-home;

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
