{
  flake.modules.nixos.time =
    { lib, ... }:
    {
      services.ntpd-rs = {
        enable = true;
        settings = {
          source =
            map
              (lib.mergeAttrs {
                # We only care about nts servers ;D
                # (if we exclude the nixos pool that is)
                mode = "nts";
                # Upgrade to Draft NTPv5 if possible :)
                ntp-version = "auto";
              })
              (
                [
                  { address = "nts.netnod.se"; }
                  { address = "time.cloudflare.com"; }
                ]
                ++ (
                  4
                  |> builtins.genList (i: {
                    address = "ptbtime${toString <| i + 1}.ptb.de";
                  })
                )
              );
        };
      };
    };
}
