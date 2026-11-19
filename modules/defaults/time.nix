{
  # NOTE: Only enable if DNS isn't too strict or Device has an RTC.
  #       If the DNS strictly needs DoT and DNSSEC and there is no RTC then
  #       no time can be fetched. Without the correct time
  #       DoT and DNSSEC fail causing a deadlock.
  den.default.nixos = {
    services.ntpd-rs = {
      enable = true;
      useNetworkingTimeServers = false;
      settings.source = [
        {
          mode = "nts-pool";
          enable-srv-resolution = true;
          address = "srv.sectime.org.";
        }
      ]
      ++
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
}
