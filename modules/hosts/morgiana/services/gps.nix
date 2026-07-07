{
  den.aspects.morgiana.nixos =
    { config, lib, ... }:
    let
      ppsDevice = "pps0";
      ppsPath = "/dev/${ppsDevice}";

      gpsDevice = "ttyAMA0";
      gpsSocket = "chrony.${gpsDevice}.sock";
      gpsSocketPath = "/run/${config.systemd.services.ntpd-rs.serviceConfig.RuntimeDirectory}/${gpsSocket}";
    in
    {
      hardware.raspberry-pi.config.all = {
        options.init_uart_baud = {
          enable = true;
          value = 9600;
        };
        dt-overlays = {
          "disable-bt" = {
            enable = true;
            params = { };
          };
          "pps-gpio,gpiopin=4" = {
            enable = true;
            params = { };
          };
        };
      };

      boot.kernelModules = [ "pps-gpio" ];

      users = {
        users.ntpd-rs = {
          isSystemUser = true;
          group = config.users.groups.ntpd-rs.name;
        };
        groups.ntpd-rs = { };
      };

      systemd.services = {
        gpsd.after = [ config.systemd.services.ntpd-rs-socket-shim.name ];

        ntpd-rs.serviceConfig = {
          # NOTE: ntpd-rs already comes with a service file that declares a static User and Group.
          #       The nixos Module tries to override it with DynamicUser unsuccessfully causing breakage.
          DynamicUser = lib.mkForce false;
          RuntimeDirectory = "ntpd-rs";
        };
        ntpd-rs-socket-shim = {
          after = [ config.systemd.services.ntpd-rs.name ];
          requires = [ config.systemd.services.ntpd-rs.name ];
          wantedBy = [ config.systemd.services.gpsd.name ];
          enableStrictShellChecks = true;
          serviceConfig.Type = "oneshot";
          script = ''
            ln -sf ${gpsSocketPath} /run/${gpsSocket}
          '';
        };
      };

      services = {
        udev.extraRules = ''
          KERNEL=="${ppsDevice}", GROUP="${config.users.users.ntpd-rs.group}", MODE="0640"
        '';

        ntpd-rs = {
          enable = true;
          useNetworkingTimeServers = false;
          settings = {
            synchronization.minimum-agreeing-sources = 1;
            source = [
              {
                mode = "sock";
                path = gpsSocketPath;
                precision = 0.001;
              }
              {
                mode = "pps";
                path = ppsPath;
                precision = 0.0000001;
              }
            ];
          };
        };
        gpsd = {
          enable = true;
          nowait = true;
          devices = [
            "/dev/${gpsDevice}"
            ppsPath
          ];
        };
      };
    };
}
