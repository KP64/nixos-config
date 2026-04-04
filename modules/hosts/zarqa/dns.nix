toplevel@{ moduleWithSystem, inputs, ... }:
{
  flake.modules.nixos.hosts-zarqa = moduleWithSystem (
    { config, system, ... }:
    nixos@{ lib, ... }:
    {
      sops.secrets =
        let
          owner = nixos.config.users.users.hickory-dns.name;
        in
        {
          zone_signing_key = { inherit owner; };
        };

      networking = {
        resolvconf.useLocalResolver = true;
        firewall =
          let
            inherit (nixos.config.services) hickory-dns;
            dns = [ hickory-dns.settings.listen_port ];
            usesDoT = builtins.any (
              zone: zone ? stores.opportunistic_encryption.enabled
            ) hickory-dns.settings.zones;
          in
          {
            allowedTCPPorts = dns ++ lib.optional usesDoT 853;
            allowedUDPPorts = dns;
          };
      };

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

      services = {
        resolved.enable = false;

        # NOTE: All paths should be fully qualified. There is some janky behaviour if not.
        hickory-dns = {
          enable = true;
          quiet = true; # They are logging wayyy too much (not a bad thing)
          package = config.packages.hickory-dns;
          settings =
            let
              dnsLib = inputs.dns.lib;
              # inherit (dnsLib.combinators) letsEncrypt;
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
                  rec {
                    zone = "srvd.space";
                    file = dnsUtil.writeZone zone rec {
                      TTL = 60;
                      SOA = {
                        nameServer = builtins.head NS;
                        adminEmail = nixos.config.invisible.email;
                        serial = 2026040200;
                      };
                      NS =
                        subdomains
                        |> builtins.attrNames
                        |> lib.filter (lib.hasPrefix "ns")
                        |> map (nsdomain: "${nsdomain}.${zone}.");
                      A = [ nixos.config.staticIPv4 ];
                      subdomains =
                        let
                          mahdiIp = toplevel.config.flake.nixosConfigurations.mahdi.config.staticIPv4;
                        in
                        {
                          ns = { inherit A; };
                          overflow = { inherit A; };
                          dumb = { inherit A; };

                          "*".A = [ mahdiIp ];
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
