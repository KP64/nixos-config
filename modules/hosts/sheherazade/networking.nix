{ inputs, moduleWithSystem, ... }:
{
  flake.modules.nixos.hosts-sheherazade = moduleWithSystem (
    { config, system, ... }:
    nixos@{ pkgs, ... }:
    {
      networking = {
        domain = "srvd.space";
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

      sops.secrets =
        let
          hickory = {
            owner = nixos.config.users.users.hickory-dns.name;
            inherit (nixos.config.users.users.hickory-dns) group;
          };
        in
        {
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
      systemd.services.hickory-dns.serviceConfig = {
        User = nixos.config.users.users.hickory-dns.name;
        Group = nixos.config.users.users.hickory-dns.group;
      };
      # TODO: Harden with DoT etc. once ready
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
                  stores = {
                    type = "recursor";
                    roots = pkgs.dns-root-data + /root.hints;
                    dnssec_policy.ValidateWithStaticKey.path = pkgs.dns-root-data + /root.key;
                  };
                }
                rec {
                  zone = nixos.config.networking.domain;
                  file = dnsUtil.writeZone zone rec {
                    TTL = 60;
                    SOA = {
                      nameServer = builtins.head NS;
                      adminEmail = "lzkfaea17@mozmail.com";
                      serial = 2025122701;
                    };
                    # TODO: This should generate based on nameserver subdomains
                    NS = 2 |> builtins.genList (i: "ns${toString <| i + 1}.${nixos.config.networking.domain}.");
                    # TODO: These IP's aren't static. Use RFC2136 to update them dynamically
                    A = [ "91.6.62.126" ];
                    AAAA = [ "2003:c2:f716:3813:a756:3a4a:8a7b:2ae6" ];
                    CAA = letsEncrypt SOA.adminEmail;
                    # TODO: load balancing should be done to the machine serving the correct service.
                    subdomains = {
                      ns1 = { inherit A AAAA; };
                      ns2 = { inherit A AAAA; }; # TODO: Add another machine that will be the 2nd NS
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
