{ moduleWithSystem, inputs, ... }:
{
  flake.modules.nixos.hosts-zarqa = moduleWithSystem (
    { config, system, ... }:
    nixos: {
      # NOTE: Hickory is denied permission to secrets. It also uses a DynamicUser.
      #       This is needed so that we can set an owner to Hickory.
      users = {
        groups.hickory-dns = { };
        users.hickory-dns = {
          group = nixos.config.users.groups.hickory-dns.name;
          isSystemUser = true;
        };
      };
      systemd.services.hickory-dns.serviceConfig = {
        User = nixos.config.users.users.hickory-dns.name;
        Group = nixos.config.users.users.hickory-dns.group;
      };

      networking.resolvconf.useLocalResolver = true;

      services = {
        resolved.enable = false;

        # NOTE: All paths should be fully qualified. There is some janky behaviour if not.
        hickory-dns = {
          enable = true;
          quiet = true;
          package = config.packages.hickory-dns;
          settings =
            let
              dnsLib = inputs.dns.lib;
              dnsUtil = inputs.dns.util.${system};
            in
            {
              zones =
                # NOTE: These "default" zones do not ship with hickory-dns by default.
                #       Therefore manually specified.
                [
                  rec {
                    zone = "localhost";
                    file = dnsUtil.writeZone zone {
                      SOA = {
                        nameServer = "localhost.";
                        adminEmail = "root@localhost";
                        serial = 2025122600;
                      };
                      NS = [ "localhost." ];
                      A = [ "127.0.0.1" ];
                      AAAA = [ "::1" ];
                    };
                  }
                  rec {
                    zone = dnsLib.mkIPv4ReverseRecord "127.0.0.1";
                    file = dnsUtil.writeZone zone {
                      SOA = {
                        nameServer = "localhost.";
                        adminEmail = "root@localhost";
                        serial = 2025122600;
                      };
                      NS = [ "localhost." ];
                      PTR = [ "localhost." ];
                    };
                  }
                  rec {
                    zone = dnsLib.mkIPv6ReverseRecord "::1";
                    file = dnsUtil.writeZone zone {
                      SOA = {
                        nameServer = "localhost.";
                        adminEmail = "root@localhost";
                        serial = 2025122600;
                      };
                      NS = [ "localhost." ];
                      PTR = [ "localhost." ];
                    };
                  }
                  rec {
                    zone = dnsLib.mkIPv4ReverseRecord "255.255.255.255";
                    file = dnsUtil.writeZone zone {
                      SOA = {
                        nameServer = "localhost.";
                        adminEmail = "root@localhost";
                        serial = 2025122600;
                      };
                      NS = [ "localhost." ];
                    };
                  }
                  rec {
                    zone = dnsLib.mkIPv4ReverseRecord "0.0.0.0";
                    file = dnsUtil.writeZone zone {
                      SOA = {
                        nameServer = "localhost.";
                        adminEmail = "root@localhost";
                        serial = 2025122600;
                      };
                      NS = [ "localhost." ];
                    };
                  }
                ]
                # Custom Zones
                ++ [
                  {
                    zone = ".";
                    zone_type = "External";
                    stores = {
                      type = "forward";
                      name_servers =
                        map
                          (ip: {
                            inherit ip;
                            trust_negative_responses = false;
                            connections = [
                              { protocol.type = "udp"; }
                              { protocol.type = "tcp"; }
                            ];
                          })
                          [
                            "9.9.9.9"
                            "149.112.112.112"
                            "1.1.1.1"
                            "1.0.0.1"
                          ];
                    };
                  }
                ];
            };
        };
      };
    }
  );
}
