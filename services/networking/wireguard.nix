{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.networking.wireguard;
  sharedOptions = {
    default = {
      autostart = lib.mkOption {
        default = true;
        type = lib.types.bool;
        example = false;
        description = "Wether to start this interface on device Startup.";
      };

      address = lib.mkOption {
        readOnly = true;
        type = lib.types.submodule {
          options = {
            ipv4 = lib.mkOption {
              default = [ ];
              type = with lib.types; listOf nonEmptyStr;
              example = [ "10.0.0.1/24" ];
              description = "The IPv4 addresses interface listens on.";
            };

            ipv6 = lib.mkOption {
              default = [ ];
              type = with lib.types; listOf nonEmptyStr;
              example = [ "fdc9:281f:04d7:9ee9::1/64" ];
              description = "The IPv4 addresses interface listens on.";
            };
          };
        };
      };

      privateKeyFile = lib.mkOption {
        readOnly = true;
        type = lib.types.path;
        description = "The path to the file containing the privateKey.";
      };
    };

    peers = {
      publicKey = lib.mkOption {
        readOnly = true;
        type = lib.types.nonEmptyStr;
        description = "The public Key of the 'Client'.";
      };

      allowedIPs = lib.mkOption {
        readOnly = true;
        type = with lib.types; listOf nonEmptyStr;
        example = [ "172.29.0.2" ];
        description = "The Addresses of the 'Client'.";
      };
    };
  };
in
{
  options.services.networking.wireguard = {
    externalInterface = lib.mkOption {
      default = "end0";
      type = lib.types.nonEmptyStr;
      example = "wlan0";
      description = "The device interface that the wg-interface uses.";
    };

    clientInterfaces = lib.mkOption {
      default = { };
      description = "The interfaces to connect to others";
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = sharedOptions.default // {
            dns = lib.mkOption {
              readOnly = true;
              description = "The DNS-Address this interface uses";
              type = with lib.types; nonEmptyListOf nonEmptyStr;
              example = [ "10.2.0.1" ];
            };

            peers = lib.mkOption {
              readOnly = true;
              description = "The list of peers this interface connects to.";
              example = [ "10.2.0.2/32" ];
              type = lib.types.listOf (
                lib.types.submodule {
                  options = sharedOptions.peers // {
                    endpoint = lib.mkOption {
                      readOnly = true;
                      type = lib.types.nonEmptyStr;
                      description = "The ip:port this uses to connect to the Peer.";
                      example = "127.0.0.1:51820";
                    };
                  };
                }
              );
            };
          };
        }
      );
    };

    # ? Wireguard isn't Server/Client.
    # ? But these terms help newbies as myself to understand :)
    serverInterfaces = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = sharedOptions.default // {
            listenPort = lib.mkOption {
              default = 51820;
              type = lib.types.port;
              example = 50000;
              description = "The port the interface listens on.";
            };

            peers = lib.mkOption {
              readOnly = true;
              type = lib.types.listOf (
                lib.types.submodule {
                  options = sharedOptions.peers // {
                    # ? Force people to use a preshared key.
                    # ? Because when we do something it should be done right.
                    # ? Security is key ;D
                    presharedKeyFile = lib.mkOption {
                      readOnly = true;
                      type = lib.types.nonEmptyStr;
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
        autoStartCount = interfaces: interfaces |> lib.attrValues |> lib.count (val: val.autostart);
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

    topology =
      let
        getNetworkName = name: "wg-${name}";
      in
      {
        networks = (
          (cfg.serverInterfaces // cfg.clientInterfaces)
          |> lib.mapAttrs' (
            name: value:
            let
              getCIDRv = addresses: if addresses == [ ] then null else builtins.head addresses;
            in
            lib.nameValuePair (getNetworkName name) {
              name = "Wireguard Net ${name}";
              cidrv4 = getCIDRv value.address.ipv4;
              cidrv6 = getCIDRv value.address.ipv6;
            }
          )
        );

        self.interfaces =
          (cfg.serverInterfaces // cfg.clientInterfaces)
          |> (lib.mapAttrs (
            name: value: {
              network = getNetworkName name;
              addresses = with value.address; ipv4 ++ ipv6;
              type = "wireguard";
              physicalConnections = lib.optional (value ? dns) (config.lib.topology.mkConnection "internet" "*");
            }
          ));
      };

    networking =
      let
        serverInterfaces =
          cfg.serverInterfaces
          |> lib.mapAttrs (
            name: value:
            let
              setNAT =
                ipv: mode:
                let
                  addresses = if (ipv == "iptables") then value.address.ipv4 else value.address.ipv6;
                in
                lib.concatLines (
                  (lib.optional (addresses != [ ]) "${ipv} -${mode} FORWARD -i ${name} -j ACCEPT")
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
              preDown = (setIPv4NAT "D") + (setIPv6NAT "D");
            }
          );

        clientInterfaces =
          cfg.clientInterfaces
          |> lib.mapAttrs (
            name: value:
            value
            // {
              address = with value.address; ipv4 ++ ipv6;
            }
          );
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
            allowedUDPPorts = [
              dnsPort
            ] ++ (serverInterfaces |> builtins.attrValues |> map (i: i.listenPort));
          };

        wg-quick.interfaces = serverInterfaces // clientInterfaces;
      };
  };
}
