toplevel: {
  # NOTE: Only enable if DNS isn't too strict or Device has an RTC.
  #       If the DNS strictly needs DoT and DNSSEC and there is no RTC then
  #       no time can be fetched. Without the correct time
  #       DoT and DNSSEC fail causing a deadlock.
  den = {
    schema.host.options.isNTPServer = toplevel.lib.mkEnableOption "Machine is an NTP Server";
    # TODO: Refactor this once NTP-Servers are implemented
    default.nixos =
      { host, lib, ... }:
      lib.optionalAttrs (!host.isNTPServer) {
        services.ntpd-rs = {
          enable = true;
          useNetworkingTimeServers = false;
          settings.source =
            map
              (address: {
                mode = "nts";
                inherit address;
              })
              (
                [
                  "nts.netnod.se"
                  "time.cloudflare.com"
                ]
                ++ (builtins.genList (i: "ptbtime${toString (i + 1)}.ptb.de") 4)
              );
        };
      };
  };
}
