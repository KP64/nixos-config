toplevel: {
  flake.modules.homeManager.users-kg-thunderbird =
    { config, ... }:
    let
      inherit (config.home) username;
      inherit (toplevel.config.flake.lib.flake) toFlattenedByDots;
    in
    {
      catppuccin.thunderbird.profile = username;

      programs.thunderbird = {
        enable = true;
        profiles.${username} = {
          isDefault = true;
          search = {
            default = "ddg";
            privateDefault = "ddg";
            force = true;
          };
          settings = toFlattenedByDots {
            extensions.autoDisableScopes = 0;
            general.autoScroll = true;
            privacy.donottrackheader.enabled = true;
            toolkit.telemetry.server = "";
            network.trr.mode = 5; # Off by choice -> Uses system DNS resolver
            mail.e2ee = {
              auto_enable = true;
              auto_disable = true;
            };
          };
        };
      };
    };
}
