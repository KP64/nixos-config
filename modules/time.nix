{
  # TODO: RTC for ALL Pis. Needed for Sane time on startup.
  #       Benefit: Learning Experience & Uncompromising DNSSEC and DoT
  # NOTE: Only enable if DNS isn't too strict or Device has an RTC.
  #       If the DNS strictly needs DoT and DNSSEC and there is no RTC then
  #       then no time can be fetched. Without the correct time
  #       DoT and DNSSEC fail causing a deadlock.
  flake.modules.nixos.time = {
    services.ntpd-rs = {
      enable = true;
      settings.source =
        map
          (address: {
            # We only care about nts servers ;D
            # (if we exclude the nixos pool that is)
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
