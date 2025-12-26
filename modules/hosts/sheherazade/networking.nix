{ inputs, moduleWithSystem, ... }:
{
  flake.modules.nixos.hosts-sheherazade = moduleWithSystem (
    { system, ... }:
    { config, pkgs, ... }:
    {
      networking = {
        domain = "srvd.space";
        firewall =
          let
            dns = [ config.services.hickory-dns.settings.listen_port ];
          in
          {
            allowedTCPPorts = dns ++ [
              853 # DoT
            ];
            allowedUDPPorts = dns;
          };
      };

      sops.secrets = {
        zone_signing_key = {
          owner = config.systemd.services.hickory-dns.serviceConfig.User;
          group = config.systemd.services.hickory-dns.serviceConfig.Group;
        };
        # "rfc2136/nameserver" = { };
        # "rfc2136/tsig_algorithm" = { };
        # "rfc2136/tsig_key" = { };
        # "rfc2136/tsig_secret" = { };
      };

      # security.acme = {
      #   acceptTerms = true;
      #   defaults = {
      #     email = "lzkfaea17@mozmail.com";
      #     dnsProvider = "rfc2136";
      #     credentialFiles =
      #       let
      #         inherit (config.sops) secrets;
      #       in
      #       {
      #         RFC2136_NAMESERVER_FILE = secrets."rfc2136/nameserver".path;
      #         RFC2136_TSIG_ALGORITHM = secrets."rfc2136/tsig_algorithm".path;
      #         RFC2136_TSIG_KEY_FILE = secrets."rfc2136/tsig_key".path;
      #         RFC2136_TSIG_SECRET_FILE = secrets."rfc2136/tsig_secret".path;
      #       };
      #     # dnsResolver = "1.1.1.1:53"; # TODO: Right resolver?
      #   };
      #   # certs.${config.networking.domain} = { inherit (config.services.nginx) group; };
      # };

      # NOTE: Hickory is denied permission to secrets. It also uses a DynamicUser.
      #       This is needed so that we can set an owner to Hickory.
      systemd.services.hickory-dns.serviceConfig = rec {
        User = "hickory-dns";
        Group = User;
      };
      # TODO: Harden with DoT etc. once ready
      services.hickory-dns = {
        enable = true;
        package = pkgs.hickory-dns.overrideAttrs (old: {
          cargoBuildFeatures = (old.cargoBuildFeatures or [ ]) ++ [
            "tls-ring" # DoT
            "https-ring" # DoH
            "quic-ring" # QUIC
            "h3-ring" # DoH3
            "dnssec-ring" # DNSSEC
            "blocklist" # allow/deny blocklists
            "recursor" # experimental recursive dns
            "text-parsing"
          ];
        });
        debug = true; # TODO: Remove
        settings =
          let
            dnsLib = inputs.dns.lib;
            inherit (dnsLib.combinators) host letsEncrypt;
            dnsUtil = inputs.dns.util.${system};
          in
          {
            # TODO: Finish Configuration. Look at examples: https://github.com/hickory-dns/hickory-dns/tree/main/tests/test-data/test_configs
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
                  zone = config.networking.domain;
                  keys = [
                    {
                      algorithm = "RSASHA256";
                      purpose = "ZoneSigning";
                      key_path = config.sops.secrets.zone_signing_key.path;
                    }
                  ];
                  file = dnsUtil.writeZone zone rec {
                    TTL = 60;
                    SOA = {
                      nameServer = builtins.head NS;
                      adminEmail = "lzkfaea17@mozmail.com";
                      serial = 2025122300;
                    };
                    # TODO: This should generate based on nameserver subdomains
                    NS = 2 |> builtins.genList (i: "ns${toString <| i + 1}.${config.networking.domain}.");
                    A = [ "79.245.221.171" ];
                    AAAA = [ "2003:c2:f708:eace:3378:8295:5534:ce14" ];
                    CAA = letsEncrypt SOA.adminEmail;
                    subdomains = {
                      redlib = host (builtins.head A) (builtins.head AAAA);
                      ns1 = { inherit A; };
                      ns2 = { inherit AAAA; };
                    };
                  };
                }
              ];
          };
      };
    }
  );
}
