{ inputs, moduleWithSystem, ... }:
{
  flake.modules.nixos.hosts-sheherazade = moduleWithSystem (
    { config, system, ... }:
    nixos@{ lib, ... }:
    {
      sops.secrets =
        let
          hickory = {
            owner = nixos.config.users.users.hickory-dns.name;
            inherit (nixos.config.users.users.hickory-dns) group;
          };
        in
        {
          "wireless.env".owner = nixos.config.users.users.wpa_supplicant.name;
          "rfc2136/nameserver" = { };
          "rfc2136/tsig_algorithm" = { };
          "rfc2136/tsig_key" = { };
          "rfc2136/tsig_secret" = { };
          zone_signing_key = hickory;
          tsig_secret_decoded = hickory // {
            format = "binary";
            sopsFile = ./tsig_key.enc;
          };
        };

      services.resolved.enable = false;
      networking = {
        domain = "srvd.space";
        resolvconf.useLocalResolver = true;
        useNetworkd = true;
        useDHCP = false;
        wireless = {
          enable = true;
          secretsFile = nixos.config.sops.secrets."wireless.env".path;
          fallbackToWPA2 = false;
          scanOnLowSignal = false;
          networks.Home-5GHz.pskRaw = "ext:HOME_WIFI_PASSWORD";
        };
        firewall =
          let
            dns = [ nixos.config.services.hickory-dns.settings.listen_port ];
          in
          {
            allowedTCPPorts = dns ++ [
              853 # DoT
            ];
            allowedUDPPorts = dns;
          };
      };

      # We don't care which interface is online here
      systemd.network.wait-online.anyInterface = true;
      boot.initrd.systemd.network.wait-online.anyInterface = true;

      systemd.network = {
        enable = true;
        networks."10-wlan0" = {
          name = "wlan0";
          linkConfig.RequiredForOnline = "routable";
          address = [ "192.168.2.224/24" ];
          gateway = [ "192.168.2.1" ];
          networkConfig =
            let
              inherit (lib) boolToYesNo;
            in
            {
              DNSSEC = boolToYesNo true;
              DNSOverTLS = boolToYesNo true;
            };
        };
      };

      security.acme = {
        acceptTerms = true;
        defaults = {
          email = "lzkfaea17@mozmail.com";
          dnsProvider = "rfc2136";
          dnsPropagationCheck = false; # Not needed because we are using local Resolver
          credentialFiles =
            let
              inherit (nixos.config.sops) secrets;
            in
            {
              RFC2136_NAMESERVER_FILE = secrets."rfc2136/nameserver".path;
              RFC2136_TSIG_ALGORITHM_FILE = secrets."rfc2136/tsig_algorithm".path;
              RFC2136_TSIG_KEY_FILE = secrets."rfc2136/tsig_key".path;
              RFC2136_TSIG_SECRET_FILE = secrets."rfc2136/tsig_secret".path;
            };
        };
      };

      # NOTE: Hickory is denied permission to secrets. It also uses a DynamicUser.
      #       This is needed so that we can set an owner to Hickory.
      users = {
        groups.hickory-dns = { };
        users.hickory-dns = {
          name = "hickory-dns";
          group = nixos.config.users.groups.hickory-dns.name;
          isSystemUser = true;
        };
      };
      systemd.services.hickory-dns = {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = nixos.config.users.users.hickory-dns.name;
          Group = nixos.config.users.users.hickory-dns.group;
        };
      };
      services.hickory-dns = {
        enable = true;
        package = config.packages.hickory-dns;
        settings =
          let
            dnsLib = inputs.dns.lib;
            inherit (dnsLib.combinators) letsEncrypt;
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
                  # TODO: Once Hickory is ready make this a recursor again and enable DoT
                  # stores = {
                  #   type = "recursor";
                  #   roots = pkgs.dns-root-data + /root.hints;
                  #   dnssec_policy.ValidateWithStaticKey.path = pkgs.dns-root-data + /root.key;
                  # };
                  stores = {
                    type = "forward";
                    name_servers =
                      lib.mapCartesianProduct
                        (
                          { protocol, upstream }:
                          {
                            socket_addr = "${upstream}:53";
                            protocol.type = protocol;
                            trust_negative_responses = false;
                          }
                        )
                        {
                          protocol = [
                            "tcp"
                            "udp"
                          ];
                          upstream = [
                            "9.9.9.9"
                            "149.112.112.112"
                            "1.1.1.1"
                            "1.0.0.1"
                          ];
                        };
                  };
                }
                rec {
                  zone = nixos.config.networking.domain;
                  file = dnsUtil.writeZone zone rec {
                    TTL = 60;
                    SOA = {
                      nameServer = builtins.head NS;
                      adminEmail = "lzkfaea17@mozmail.com";
                      serial = 2025123101;
                    };
                    # TODO: This should generate based on nameserver subdomains
                    NS = 2 |> builtins.genList (i: "ns${toString <| i + 1}.${nixos.config.networking.domain}.");
                    # TODO: These IP's aren't static. Use RFC2136 to update them dynamically
                    A = [ "79.245.216.105" ];
                    CAA = letsEncrypt SOA.adminEmail;
                    subdomains = {
                      "*" = { inherit A; };
                      ns1 = { inherit A; };
                      ns2 = { inherit A; };
                    };
                  };
                  stores = {
                    type = "sqlite";
                    zone_file_path = file;
                    journal_file_path = "${nixos.config.networking.domain}_dnssec_update.jrnl";
                    allow_update = true;
                    tsig_keys = [
                      {
                        name = "tsig-key";
                        algorithm = "hmac-sha256";
                        # NOTE: 💢 Hickory requires the base64-decoded secret.
                        key_file = nixos.config.sops.secrets.tsig_secret_decoded.path;
                      }
                    ];
                  };
                  keys = [
                    {
                      algorithm = "RSASHA256";
                      purpose = "ZoneSigning";
                      key_path = nixos.config.sops.secrets.zone_signing_key.path;
                    }
                  ];
                }
              ];
          };
      };
    }
  );
}
