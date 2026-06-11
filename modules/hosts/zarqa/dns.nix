toplevel@{ moduleWithSystem, inputs, ... }:
{
  flake-file.inputs.dns = {
    type = "github";
    owner = "kirelagin";
    repo = "dns.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.zarqa.nixos = moduleWithSystem (
    { config, system, ... }:
    nixos@{ lib, ... }:
    let
      inherit (nixos.config) staticIPv4 staticIPv6;
    in
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

      networking = {
        resolvconf.useLocalResolver = true;
        firewall =
          let
            dnsPort = 53;
          in
          {
            allowedTCPPorts = [ dnsPort ];
            allowedUDPPorts = [ dnsPort ];
          };
      };

      topology = lib.mkIf (nixos.config ? topology) {
        self.services.hickory-dns.details."Primary Zones".text =
          let
            # These self-evident zones only clutter the topology
            ignoredZones = [
              "localhost"
              "1.0.0.127.in-addr.arpa"
              "1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa"
              "255.255.255.255.in-addr.arpa"
              "0.0.0.0.in-addr.arpa"
            ];
          in
          nixos.config.services.hickory-dns.settings.zones
          |> builtins.filter (z: z.zone_type == "Primary")
          |> map (z: z.zone)
          |> builtins.filter (z: !builtins.elem z ignoredZones)
          |> toString;
      };

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
              listen_addrs_ipv4 = [
                "127.0.0.1"
                staticIPv4
              ];
              listen_addrs_ipv6 = [
                "::1"
                staticIPv6
              ];

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
                        serial = 2026060700;
                      };
                      NS =
                        subdomains
                        |> builtins.attrNames
                        |> lib.filter (lib.hasPrefix "ns")
                        |> map (nsdomain: "${nsdomain}.${zone}.");
                      A = [ staticIPv4 ];
                      AAAA = [ staticIPv6 ];
                      subdomains =
                        let
                          inherit (toplevel.config.flake.nixosConfigurations) mahdi morgiana;

                          getServices =
                            host:
                            host
                            |> (host: host.config.services.nginx.virtualHosts // host.config.services.caddy.virtualHosts)
                            |> builtins.attrNames
                            |> map (lib.removeSuffix ".${zone}");

                          mahdiServices = getServices mahdi;
                          morgianaServices = getServices morgiana;

                          services =
                            nixos
                            |> getServices
                            |> builtins.filter (service: !builtins.elem service mahdiServices)
                            |> builtins.filter (service: !builtins.elem service morgianaServices);
                        in
                        {
                          ns = { inherit A AAAA; };
                        }
                        // lib.genAttrs services (_: {
                          inherit A AAAA;
                        })
                        // lib.genAttrs morgianaServices (_: {
                          A = [ morgiana.config.staticIPv4 ];
                          AAAA = [ morgiana.config.staticIPv6 ];
                        })
                        // lib.genAttrs mahdiServices (_: {
                          A = [ mahdi.config.staticIPv4 ];
                          AAAA = [ mahdi.config.staticIPv6 ];
                        });
                    };
                  }
                ];
            };
        };
      };
    }
  );
}
