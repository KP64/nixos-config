{ inputs, ... }:
{
  flake.modules.homeManager.users-kg =
    { config, ... }:
    let
      invisible = import (inputs.nix-invisible + /users/${config.home.username}.nix);
    in
    {
      sops.secrets."weather.json" = { };

      programs.hyprpanel = {
        enable = true;
        settings = {
          menus.clock.weather = {
            unit = "metric";
            inherit (invisible) location;
            key = config.sops.secrets."weather.json".path;
          };

          bar = {
            clock = {
              format = "%R";
              icon = "";
            };
            launcher.autoDetectIcon = true;
            battery.hideLabelWhenFull = true;
            layouts."*" = {
              left = [
                "dashboard"
                "battery"
                "volume"
              ];
              middle = [
                "weather"
                "cava"
                "clock"
              ];
              right = [
                "systray"
                "network"
                "bluetooth"
                "notifications"
              ];
            };
          };
        };
      };
    };
}
