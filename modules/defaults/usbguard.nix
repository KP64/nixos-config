{ den, lib, ... }: {
  den = {
    quirks.adminYubikeyUSBGuardRules.description = "USBGuard rules generated from user YubiKeys";

    # Transform the exposed YubiKeys into USBGuard rules.
    policies.map-yubis-to-usbguard =
      { host, ... }:
      let
        inherit (den.lib.policy) pipe;
        currentHost = host.name;
      in
      [
        (pipe.from "yubikeys" [
          (pipe.collectAll ({ user, host, ... }: host.name == currentHost && user.isAdmin))
          (pipe.transform (
            key:
            ''allow id ${key.vendorID}:${key.modelID} serial "" name "${key.name}" hash "${key.hash}" with-interface equals { ${toString key.interfaces} } with-connect-type "hotplug"''
          ))
          (pipe.as "adminYubikeyUSBGuardRules")
        ])
      ];
    schema.host.includes = [ den.policies.map-yubis-to-usbguard ];

    default.nixos =
      {
        host,
        config,
        pkgs,
        adminYubikeyUSBGuardRules,
        ...
      }:
      lib.mkIf host.isServer {
        services.usbguard = {
          enable = true;

          # NOTE: Port numbering is unstable/inconsistent on most devices each boot.
          deviceRulesWithPort = false;
          implicitPolicyTarget = "reject";
          presentControllerPolicy = "apply-policy";
          restoreControllerDeviceState = true;

          ruleFile =
            let
              hostCfg = ../hosts/${config.networking.hostName}/usbguard.cfg;
            in
            pkgs.writeText "usbguard-cfg" (
              (builtins.readFile hostCfg) + (lib.concatLines <| lib.flatten <| adminYubikeyUSBGuardRules)
            );
        };
      };
  };
}
