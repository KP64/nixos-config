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

    # TODO: replace freestyle attrs?
    clientInterfaces = lib.mkOption {
      default = { };
      type = lib.types.attrs;
      description = "The interfaces to connect to others";
      example = {
        wg1 = {
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
              example = false;
              description = "Wether to start this interface.";
            };

            # TODO: Add ipv6 versions
            address = lib.mkOption {
              readOnly = true;
              type = with lib.types; listOf str;
              example = [ "170.29.0.1/30" ];
              description = "The addresses interface listens on.";
            };

            listenPort = lib.mkOption {
              readOnly = true;
              type = lib.types.port;
              example = 51820;
              description = "The port the interface listens on.";
            };

            privateKeyFile = lib.mkOption {
              readOnly = true;
              type = lib.types.str;
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

    networking =
      let
        dnsPort = 53;

        ipv4tables = "${pkgs.iptables}/bin/iptables";

        setNAT =
          mode: addresses:
          lib.concatLines (
            map (
              addr:
              "${ipv4tables} -t nat -${mode} POSTROUTING -s ${addr} -o ${cfg.externalInterface} -j MASQUERADE"
            ) addresses
          );

        serverInterfaces = lib.mapAttrs' (name: value: {
          inherit name;
          value = value // {
            postUp =
              ''
                ${ipv4tables} -A FORWARD -i ${name} -j ACCEPT
              ''
              + (setNAT "A" value.address);
            postDown =
              ''
                ${ipv4tables} -D FORWARD -i ${name} -j ACCEPT
              ''
              + (setNAT "D" value.address);
          };
        }) cfg.serverInterfaces;
      in
      {
        nat = {
          enable = true;
          # TODO: Enable IPv6
          enableIPv6 = false;
          inherit (cfg) externalInterface;
          internalInterfaces = builtins.attrNames cfg.serverInterfaces;
        };

        firewall = {
          allowedTCPPorts = [ dnsPort ];
          allowedUDPPorts = [ dnsPort ] ++ (map (i: i.listenPort) (builtins.attrValues cfg.serverInterfaces));
        };

        wg-quick.interfaces = serverInterfaces // cfg.clientInterfaces;
      };
  };
}
