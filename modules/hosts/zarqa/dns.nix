toplevel@{ moduleWithSystem, inputs, ... }:
{
  flake.modules.nixos.hosts-zarqa = moduleWithSystem (
    { config, system, ... }:
    nixos@{ lib, ... }:
    {
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
              listen_addrs_ipv4 = [ "127.0.0.1" ];
              listen_addrs_ipv6 = [ "::1" ];

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
                  rec {
                    zone = "srvd.space";
                    file = dnsUtil.writeZone zone rec {
                      TTL = 60;
                      SOA = {
                        nameServer = builtins.head NS;
                        adminEmail = nixos.config.invisible.email;
                        serial = 2026040900;
                      };
                      NS =
                        subdomains
                        |> builtins.attrNames
                        |> lib.filter (lib.hasPrefix "ns")
                        |> map (nsdomain: "${nsdomain}.${zone}.");
                      A = [ nixos.config.staticIPv4 ];
                      AAAA = [ nixos.config.staticIPv6 ];
                      # TODO: Find a better way for this.
                      subdomains =
                        let
                          inherit (toplevel.config.flake.nixosConfigurations) mahdi morgiana;
                        in
                        {
                          ns = { inherit A AAAA; };
                        }
                        # Zarqa Services
                        // lib.genAttrs [ "atuin" "dumb" "overflow" ] (_: {
                          inherit A AAAA;
                        })
                        # Morgiana Services
                        // lib.genAttrs [ "redlib" ] (_: {
                          A = [ morgiana.config.staticIPv4 ];
                          AAAA = [ morgiana.config.staticIPv6 ];
                        })
                        # Mahdi Services (for now wildcard as a default)
                        // {
                          "*" = {
                            A = [ mahdi.config.staticIPv4 ];
                            AAAA = [ mahdi.config.staticIPv6 ];
                          };
                        };
                    };
                  }
                ];
            };
        };
      };
    }
  );
}
