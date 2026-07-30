{ den, ... }: {
  den.aspects.morgiana = {
    includes = with den.aspects; [
      acme
      dyndns
    ];

    nixos =
      { config, lib, ... }:
      let
        ppsDevice = "pps0";
        ppsPath = "/dev/${ppsDevice}";

        gpsDevice = "ttyAMA0";
        gpsSocket = "chrony.${gpsDevice}.sock";
        gpsSocketPath = "/run/${config.systemd.services.ntpd-rs.serviceConfig.RuntimeDirectory}/${gpsSocket}";

        ntsPort = 4460;
        ntpPort = 123;

        subdomain = "nts";
        ntsDomain = "${subdomain}.${config.networking.domain}";
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

        security.acme.certs.${ntsDomain} = { };

        systemd.services = {
          gpsd = {
            bindsTo = [ config.systemd.services.ntpd-rs.name ];
            after = map (service: service.name) (
              with config.systemd.services;
              [
                ntpd-rs
                ntpd-rs-socket-shim
              ]
            );
          };

          ntpd-rs = {
            wants = [ config.systemd.services."acme-${ntsDomain}".name ];
            after = [ config.systemd.services."acme-${ntsDomain}".name ];
            serviceConfig = {
              # NOTE: ntpd-rs already comes with a service file that declares a static User and Group.
              #       The nixos Module tries to override it with DynamicUser unsuccessfully causing breakage.
              DynamicUser = lib.mkForce false;
              RuntimeDirectory = "ntpd-rs";
              LoadCredential =
                map (cred: "${cred}:${config.security.acme.certs.${ntsDomain}.directory}/${cred}")
                  [
                    "key.pem"
                    "fullchain.pem"
                  ];
            };
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

        networking.firewall = {
          allowedTCPPorts = [ ntsPort ];
          allowedUDPPorts = [ ntpPort ];
        };

        services = {
          oink.domains = [
            {
              inherit (config.networking) domain;
              inherit subdomain;
            }
          ];

          udev.extraRules = ''
            KERNEL=="${ppsDevice}", GROUP="${config.users.users.ntpd-rs.group}", MODE="0640"
          '';

          ntpd-rs = {
            enable = true;
            useNetworkingTimeServers = false;
            settings =
              let
                accept-ntp-versions = [
                  4
                  5
                ];
              in
              {
                synchronization.minimum-agreeing-sources = 1;
                nts-ke-server = [
                  {
                    listen = "[::]:${toString ntsPort}";
                    certificate-chain-path = "/run/credentials/${config.systemd.services.ntpd-rs.name}/fullchain.pem";
                    private-key-path = "/run/credentials/${config.systemd.services.ntpd-rs.name}/key.pem";
                    inherit accept-ntp-versions;
                  }
                ];
                server = [
                  {
                    listen = "[::]:${toString ntpPort}";
                    require-nts = "deny";
                    inherit accept-ntp-versions;
                  }
                ];
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
  };
}
