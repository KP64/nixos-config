{
  den.default.nixos = { config, ... }: {
    systemd.network.enable = true;
    networking = {
      useDHCP = false;
      dhcpcd.enable = false;

      wireless = {
        fallbackToWPA2 = false;
        scanOnLowSignal = 1 < (builtins.length (builtins.attrNames config.networking.wireless.networks));
      };

      firewall = {
        pingLimit = "10/second burst 20 packets";
        checkReversePath = "strict";
        filterForward = true;
      };
      nftables = {
        enable = true;
        flattenRulesetFile = true;
        flushRuleset = true;
      };
    };
  };
}
