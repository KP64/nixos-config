toplevel@{ inputs, moduleWithSystem, ... }:
{
  flake-file.inputs.dns = {
    type = "github";
    owner = "kirelagin";
    repo = "dns.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.zarqa.nixos = moduleWithSystem (
    { system, ... }:
    { config, lib, ... }:
    let
      zoneDir = "${config.services.bind.directory}/zones";
    in
    {
      services.resolved.enable = false;
      networking.firewall =
        let
          bindPorts = lib.unique (
            with config.services.bind;
            [
              listenOnPort
              listenOnIpv6Port
            ]
          );
        in
        {
          allowedTCPPorts = bindPorts ++ [
            853 # DoT
          ];
          allowedUDPPorts = bindPorts ++ [
            784 # DoQ
            5353 # mDNS
            5355 # LLMNR
          ];
        };

      systemd.services.bind-init-zones =
        let
          nsSubDomains = builtins.genList (i: "ns${toString (i + 1)}") 2;

          dnsUtil = inputs.dns.util.${system};
          inherit (inputs.dns.lib) combinators;
          internalZone = dnsUtil.writeZone config.networking.domain rec {
            SOA = {
              nameServer = builtins.head NS;
              adminEmail = config.invisible.email;
              serial = 2026062600;
            };
            CAA = combinators.letsEncrypt config.invisible.email;
            NS =
              subdomains
              |> builtins.attrNames
              |> builtins.filter (lib.hasPrefix "ns")
              |> map (nsdomain: "${nsdomain}.${config.networking.domain}.");
            A = [ config.staticIPv4 ];
            AAAA = [ config.staticIPv6 ];
            subdomains =
              let
                inherit (toplevel.config.flake.nixosConfigurations) mahdi morgiana;

                getServices =
                  hostCfg:
                  (
                    (lib.optionalAttrs hostCfg.services.nginx.enable hostCfg.services.nginx.virtualHosts)
                    // (lib.optionalAttrs hostCfg.services.caddy.enable hostCfg.services.caddy.virtualHosts)
                  )
                  |> builtins.attrNames
                  |> map (lib.removeSuffix ".${config.networking.domain}");

                mahdiServices = getServices mahdi.config;
                morgianaServices = getServices morgiana.config;

                services =
                  config
                  |> getServices
                  |> builtins.filter (service: !builtins.elem service mahdiServices)
                  |> builtins.filter (service: !builtins.elem service morgianaServices);
              in
              (lib.genAttrs (nsSubDomains ++ services) (_: {
                inherit A AAAA;
              }))
              // (lib.genAttrs morgianaServices (_: {
                A = [ morgiana.config.staticIPv4 ];
                AAAA = [ morgiana.config.staticIPv6 ];
              }))
              // (lib.genAttrs mahdiServices (_: {
                A = [ mahdi.config.staticIPv4 ];
                AAAA = [ mahdi.config.staticIPv6 ];
              }));
          };
        in
        {
          description = "Initialize writable BIND zones";
          before = [ "bind.service" ];
          wantedBy = [ "bind.service" ];
          serviceConfig.Type = "oneshot";
          enableStrictShellChecks = true;
          script = ''
            install -d -m0750 -o named -g named ${zoneDir}

            # --update=none for those that shouldn't be replaced
            cp --update=all ${internalZone} ${zoneDir}/internal-${config.networking.domain}.zone
            chown named:named ${zoneDir}/internal-${config.networking.domain}.zone
            chmod 0640 ${zoneDir}/internal-${config.networking.domain}.zone
          '';
        };

      services.bind = {
        enable = true;
        # NOTE: Cannot check config because external files
        checkConfig = false;

        cacheNetworks = [
          "127.0.0.0/24"
          "::1/128"

          "192.168.178.0/24"
          "fd34:683f:dc06:0::/64"
        ];
        forward = "only";
        forwarders = [
          "9.9.9.9"
          "149.112.112.112"
          "2620:fe::fe"
          "2620:fe::9"

          "1.1.1.1"
          "1.0.0.1"
          "2606:4700:4700::1111"
          "2606:4700:4700::1001"
        ];
        extraOptions = ''
          version "not available";
          empty-zones-enable yes;
          recursion yes;
        '';
        extraConfig = ''
          view internal {
            match-clients { cachenetworks; };

            zone "${config.networking.domain}" {
                type primary;
                file "${zoneDir}/internal-${config.networking.domain}.zone";
            };
          };
        '';
      };
    }
  );
}
