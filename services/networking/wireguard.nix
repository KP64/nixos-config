{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.networking.wireguard;
in
{
  options.services.networking.wireguard = {
    externalInterface = lib.mkOption {
      default = "end0";
      type = lib.types.str;
      example = "wlan0";
    };

    clientInterfaces = lib.mkOption {
      default = { };
      type = lib.types.attrs;
      description = "The interfaces to connect to others";
      example.wg1 = {
        autostart = false;
        address = [ "10.0.0.0/32" ];
        dns = [ "1.1.1.1" ];
        privateKeyFile = "Path to your key";
        peers = [
          {
            publicKey = "Your public Key";
            allowedIPs = [ "0.0.0.0/0" ];
            endpoint = "ip:port (of the server)";
          }
        ];
      };
    };

    # ? Wireguard isn't Server/Client.
    # ? But these terms help newbies as myself to understand :)
    serverInterfaces = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            autostart = lib.mkOption {
              default = true;
              type = lib.types.bool;
              example = false;
              description = "Wether to start this interface.";
            };

            address = lib.mkOption {
              readOnly = true;
              type = lib.types.submodule {
                options = {
                  ipv4 = lib.mkOption {
                    default = [ ];
                    type = with lib.types; listOf str;
                    example = [ "10.0.0.1/24" ];
                    description = "The IPv4 addresses interface listens on.";
                  };

                  ipv6 = lib.mkOption {
                    default = [ ];
                    type = with lib.types; listOf str;
                    example = [ "fdc9:281f:04d7:9ee9::1/64" ];
                    description = "The IPv4 addresses interface listens on.";
                  };
                };
              };
            };

            listenPort = lib.mkOption {
              default = 51820;
              type = lib.types.port;
              example = 50000;
              description = "The port the interface listens on.";
            };

            privateKeyFile = lib.mkOption {
              readOnly = true;
              type = lib.types.path;
              description = "The path to the file containing the privateKey.";
            };

            peers = lib.mkOption {
              readOnly = true;
              type = lib.types.listOf (
                lib.types.submodule {
                  options = {
                    publicKey = lib.mkOption {
                      readOnly = true;
                      type = lib.types.str;
                      description = "The public Key of the 'Client'.";
                    };

                    allowedIPs = lib.mkOption {
                      readOnly = true;
                      type = with lib.types; listOf str;
                      example = [ "172.29.0.2" ];
                      description = "The Addresses of the 'Client'.";
                    };

                    # ? Force people to use a preshared key.
                    # ? Because when we do something it should be done right.
                    # ? Security is key ;D
                    presharedKeyFile = lib.mkOption {
                      readOnly = true;
                      type = lib.types.str;
                      description = "The path to the File containing the preshared key.";
                    };
                  };
                }
              );
            };
          };
        }
      );
    };
  };

  config = lib.mkIf (cfg.serverInterfaces != { } || cfg.clientInterfaces != { }) {
    assertions =
      let
        autoStartCount = interfaces: (lib.count (val: val.autostart) (lib.attrValues interfaces));
        autoClients = autoStartCount cfg.clientInterfaces;
      in
      [
        {
          assertion = !(((autoStartCount cfg.serverInterfaces) > 0) && (autoClients > 0));
          message = "You can't have wireguard running the device as a 'Server' and 'Client' simultaneously!";
        }
        {
          assertion = autoClients <= 1;
          message = "You can't be connected to multiple endpoints at the same time!";
        }
      ];

    # TODO: Add clientInterfaces in Topology
    # TODO: Check whether CIDRv is correct
    topology = {
      networks = lib.mapAttrs (
        name: value:
        let
          getCIDRv = addresses: if addresses == [ ] then null else builtins.head addresses;
        in
        {
          name = "Wireguard Net ${name}";
          cidrv4 = getCIDRv value.address.ipv4;
          cidrv6 = getCIDRv value.address.ipv6;
        }
      ) cfg.serverInterfaces;

      self.interfaces = lib.mapAttrs (name: value: {
        addresses = with value.address; ipv4 ++ ipv6;
        network = name;
        type = "wireguard";
      }) cfg.serverInterfaces;
    };

    networking =
      let
        serverInterfaces = lib.mapAttrs (
          name: value:
          let
            setNAT =
              ipv: mode:
              let
                addresses = if (ipv == "iptables") then value.address.ipv4 else value.address.ipv6;
              in
              lib.concatLines (
                (lib.optional ((builtins.length addresses) != 0) "${ipv} -${mode} FORWARD -i ${name} -j ACCEPT")
                ++ (map (
                  addr:
                  "${pkgs.iptables}/bin/${ipv} -t nat -${mode} POSTROUTING -s ${addr} -o ${cfg.externalInterface} -j MASQUERADE"
                ) addresses)
              );

            setIPv4NAT = setNAT "iptables";
            setIPv6NAT = setNAT "ip6tables";
          in
          value
          // {
            address = with value.address; ipv4 ++ ipv6;
            postUp = (setIPv4NAT "A") + (setIPv6NAT "A");
            postDown = (setIPv4NAT "D") + (setIPv6NAT "D");
          }
        ) cfg.serverInterfaces;
      in
      {
        nat = {
          enable = true;
          enableIPv6 = true;
          inherit (cfg) externalInterface;
          internalInterfaces = builtins.attrNames cfg.serverInterfaces;
        };

        firewall =
          let
            dnsPort = 53;
          in
          {
            allowedTCPPorts = [ dnsPort ];
            allowedUDPPorts = [ dnsPort ] ++ (map (i: i.listenPort) (builtins.attrValues cfg.serverInterfaces));
          };

        wg-quick.interfaces = serverInterfaces // cfg.clientInterfaces;
      };
  };
}
