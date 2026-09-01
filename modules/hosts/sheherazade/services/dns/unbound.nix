toplevel@{ moduleWithSystem, ... }:
{
  den.aspects.sheherazade.nixos = moduleWithSystem (
    { system, ... }:
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      inherit (toplevel.config.flake.topology.${system}.config) networks;
    in
    {
      boot.kernel.sysctl = toplevel.config.lib.flake.util.toFlattenedByDots {
        net.core =
          let
            getRamAmount =
              opt:
              let
                amountAndUnit = lib.splitStringBy (
                  prev: curr:
                  builtins.match "[0-9]" prev != null
                  && builtins.match "[${lib.concatStrings <| builtins.attrNames <| multiplier}]" curr != null
                ) true opt;
                multiplier = rec {
                  k = 1024; # KiB
                  m = k * 1024; # MiB
                };
              in
              (amountAndUnit |> builtins.head |> lib.toInt) * multiplier.${lib.last amountAndUnit};
          in
          {
            rmem_max = getRamAmount config.services.unbound.settings.server.so-rcvbuf;
            wmem_max = getRamAmount config.services.unbound.settings.server.so-sndbuf;
          };
      };

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

              # Possible because of libevent
              outgoing-range = 8192;
              num-queries-per-thread = 4096;

              so-rcvbuf = "8m";
              so-sndbuf = "8m";
            };
          };
        };
      };
    }
  );
}
