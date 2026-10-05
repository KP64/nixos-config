{
  den.default.nixos = { config, ... }: {
    services.usbguard =
      let
        cfgPath = ./hosts/${config.networking.hostName}/usbguard.cfg;
        cfgExists = builtins.pathExists cfgPath;
      in
      {
        enable = cfgExists;
        # NOTE: Port numbering is unstable/inconsistent on most devices each boot.
        deviceRulesWithPort = false;
        implicitPolicyTarget = "reject";
        presentControllerPolicy = "apply-policy";
        restoreControllerDeviceState = true;
        ruleFile = cfgPath;
      };
  };
}
