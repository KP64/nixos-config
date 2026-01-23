{ moduleWithSystem, inputs, ... }:
{
  flake.modules.nixos.hosts-sheherazade = moduleWithSystem (
    { config, system, ... }:
    nixos@{ lib, pkgs, ... }:
    {
      networking = {
        resolvconf.useLocalResolver = true;
        firewall =
          let
            inherit (nixos.config.services) hickory-dns;
            dns = [ hickory-dns.settings.listen_port ];
            usesDoT =
              hickory-dns.settings.zones |> builtins.any (zone: zone ? stores.opportunistic_encryption.enabled);
          in
          {
            allowedTCPPorts = dns ++ lib.optional usesDoT 853;
            allowedUDPPorts = dns;
          };
      };

      sops.secrets = {
        zone_signing_key = { };
        tsig_secret_decoded = {
          format = "binary";
          sopsFile = ./tsig_key.enc;
        };
      };

      # NOTE: Hickory is denied permission to secrets otherwise.
      systemd.services.hickory-dns.serviceConfig.LoadCredential =
        map (cred: "${cred}:${nixos.config.sops.secrets.${cred}.path}")
          [
            "zone_signing_key"
            "tsig_secret_decoded"
          ];

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
              inherit (dnsLib.combinators) letsEncrypt;
              dnsUtil = inputs.dns.util.${system};
              secretsDir = "/run/credentials/hickory-dns.service";
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
                      opportunistic_encryption.enabled.persistence.path = "${nixos.config.services.hickory-dns.settings.directory}/opp_enc_state.toml";
                    };
                  }
                  rec {
                    zone = nixos.config.networking.domain;
                    file = dnsUtil.writeZone zone rec {
                      TTL = 60;
                      SOA = {
                        nameServer = builtins.head NS;
                        adminEmail = "lzkfaea17@mozmail.com";
                        serial = 2026011600;
                      };
                      NS =
                        subdomains
                        |> builtins.attrNames
                        |> builtins.filter (lib.hasPrefix "ns")
                        |> map (subdomain: "${subdomain}.${nixos.config.networking.domain}.");
                      # TODO: These IP's aren't static. Use RFC2136 to update them dynamically
                      A = [ "79.245.222.16" ];
                      CAA = letsEncrypt SOA.adminEmail;
                      subdomains = {
                        "*" = { inherit A; };
                        ns1 = { inherit A; };
                        ns2 = { inherit A; };
                      };
                    };
                    stores = {
                      type = "sqlite";
                      zone_path = file;
                      journal_path = "${nixos.config.networking.domain}_dnssec_update.jrnl";
                      allow_update = true;
                      tsig_keys = lib.singleton {
                        name = "tsig-key";
                        algorithm = "hmac-sha256";
                        # NOTE: 💢 Hickory requires the base64-DECODED secret.
                        key_file = "${secretsDir}/tsig_secret_decoded";
                      };
                    };
                    keys = lib.singleton {
                      algorithm = "RSASHA256";
                      purpose = "ZoneSigning";
                      key_path = "${secretsDir}/zone_signing_key";
                    };
                  }
                ];
            };
        };
      };
    }
  );
}
