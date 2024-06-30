{
  lib,
  config,
  username,
  ...
}:
{
  options.apps.thunderbird.enable = lib.mkEnableOption "Enables Thunderbird";

  config = lib.mkIf config.apps.thunderbird.enable {
    home-manager.users.${username}.programs.thunderbird = {
      enable = true;
      profiles.kg = {
        isDefault = true;
        settings = {
          "privacy.donottrackheader.enabled" = true;
        };
      };
    };
  };
}
