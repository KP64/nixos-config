toplevel@{ moduleWithSystem, ... }:
{
  den.aspects.sheherazade.nixos = moduleWithSystem (
    { system, ... }:
    { pkgs, ... }:
    let
      inherit (toplevel.config.flake.topology.${system}.config) networks;
    in
    {
      services = {
        resolved.enable = false;
        unbound = {
          enable = true;
          # NOTE: If keys rotate before nixpkgs can catch up by updating dns-root-data
          #       DNSSEC validation could fail. Enable this and remove `trust-anchor-file`
          #       from settings should that ever happen. The way it currently is,
          #       is technically more reproducible.
          enableRootTrustAnchor = false;
          settings = {
            server = {
              port = 5353;
              # NOTE: This is badly named. Apparently
              #       it should be the CPU core count
              num-threads = 4;
              prefer-ip6 = true;
              access-control = [
                "127.0.0.0/8 allow"
                "::1/128 allow"
                "${networks.home.cidrv4} allow"
                "${networks.home.cidrv6} allow"
                "0.0.0.0/0 refuse"
                "::/0 refuse"
              ];
              trust-anchor-file = "${pkgs.dns-root-data}/root.key";
              root-hints = "${pkgs.dns-root-data}/root.hints";

              harden-referral-path = true;
              qname-minimisation-strict = true;

              harden-large-queries = true;
              harden-unverified-glue = true;
              harden-algo-downgrade = true;
              harden-unknown-additional = true;
              use-caps-for-id = true;
              deny-any = true;

              answer-cookie = true;

              private-domain = [ "home.arpa" ];
              private-address = [
                "10.0.0.0/8"
                "172.16.0.0/12"
                "192.168.0.0/16"
                "169.254.0.0/16"
                "fd00::/8"
                "fe80::/10"

                "127.0.0.0/8"
                "::ffff:0:0/96"
              ];

              prefetch = true;
              prefetch-key = true;

              hide-identity = true;
              hide-version = true;
              hide-http-user-agent = true;

              rrset-cache-size = "100m";
              msg-cache-size = "50m";
            };
          };
        };
      };
    }
  );
}
