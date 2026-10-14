{ den, ... }: {
  den = {
    quirks.additionalUSBGuardRules.description = "Additional usbguard rules contributed by Admins";
    policies.expose-additional-usbguard-rules =
      { user, lib, ... }:
      lib.optional user.isAdmin (
        den.lib.policy.pipe.from "additionalUSBGuardRules" [ den.lib.policy.pipe.expose ]
      );
    schema.user.includes = [ den.policies.expose-additional-usbguard-rules ];

    default.includes = [ den.aspects.usbguard ];
    aspects.usbguard.nixos =
      {
        config,
        lib,
        pkgs,
        additionalUSBGuardRules,
        ...
      }:
      {
        services.usbguard =
          let
            hostCfg = ../hosts/${config.networking.hostName}/usbguard.cfg;
          in
          {
            enable = builtins.pathExists hostCfg;
            # NOTE: Port numbering is unstable/inconsistent on most devices each boot.
            deviceRulesWithPort = false;
            implicitPolicyTarget = "reject";
            presentControllerPolicy = "apply-policy";
            restoreControllerDeviceState = true;
            ruleFile = lib.mkIf config.services.usbguard.enable (
              pkgs.writeText "usbguard-cfg" (
                (builtins.readFile hostCfg) + (lib.concatLines (lib.flatten additionalUSBGuardRules))
              )
            );
          };
      };
  };
}
