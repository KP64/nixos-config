{ den, lib, ... }:
let
  inherit (lib.types)
    listOf
    submodule
    strMatching
    str
    nonEmptyListOf
    nullOr
    enum
    ;
in
{
  den = {
    quirks.adminYubikeyUSBGuardRules.description = "USBGuard rules generated from user admin's YubiKeys";

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
            ''allow id ${key.vendorID}:${key.modelID} serial "" name "${key.name}" hash "${key.hash}" with-interface equals-ordered { ${toString key.interfaces} } with-connect-type "hotplug"''
          ))
          (pipe.as "adminYubikeyUSBGuardRules")
        ])
      ];
    schema.host = {
      includes = [ den.policies.map-yubis-to-usbguard ];

      options.usbguardCfg = lib.mkOption {
        default = [ ];
        type = listOf (submodule {
          options =
            let
              hashType = strMatching ".{44}";
            in
            {
              id = lib.mkOption {
                type = strMatching ".{4}:.{4}";
                apply = i: "id ${i}";
              };
              serial = lib.mkOption {
                type = str;
                apply = s: ''serial "${s}"'';
              };
              name = lib.mkOption {
                type = str;
                apply = n: ''name "${n}"'';
              };
              hash = lib.mkOption {
                type = hashType;
                apply = h: ''hash "${h}"'';
              };
              parent-hash = lib.mkOption {
                default = null;
                type = nullOr hashType;
                apply = ph: if ph == null then null else ''parent-hash "${ph}"'';
              };
              interfaces = lib.mkOption {
                type = nonEmptyListOf (strMatching ".{2}:.{2}:.{2}");
                apply =
                  i:
                  "with-interface ${
                    if (builtins.length i == 1) then (builtins.head i) else "equals-ordered { ${toString i} }"
                  }";
              };
              connect-type = lib.mkOption {
                type = enum [
                  ""
                  "hardwired"
                  "hotplug"
                  "unknown"
                ];
                apply = c: ''with-connect-type "${c}"'';
              };
            };
        });
      };
    };

    default.nixos =
      {
        config,
        host,
        adminYubikeyUSBGuardRules,
        ...
      }:
      let
        hostRules =
          host.usbguardCfg
          |> map (
            device:
            device
            |> builtins.attrValues
            |> builtins.filter (v: v != null)
            |> toString
          )
          |> lib.concatLines;
      in
      lib.mkIf (host.usbguardCfg != [ ]) {
        services.usbguard = {
          enable = true;
          IPCAllowedGroups = [ config.users.groups.wheel.name ];

          # NOTE: Port numbering is unstable/inconsistent on most devices each boot.
          deviceRulesWithPort = false;
          implicitPolicyTarget = "reject";
          presentControllerPolicy = "apply-policy";
          restoreControllerDeviceState = true;

          rules = hostRules + (lib.concatLines <| lib.flatten <| adminYubikeyUSBGuardRules);
        };
      };
  };
}
