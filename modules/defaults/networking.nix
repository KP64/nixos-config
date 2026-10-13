{
  den.default.nixos = {
    systemd.network.enable = true;
    networking = {
      useDHCP = false;
      dhcpcd.enable = false;

      wireless = {
        fallbackToWPA2 = false;
        scanOnLowSignal = false;
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
