{ inputs, ... }:
{
  flake.modules.homeManager.users-kg-hyprpanel =
    { config, pkgs, ... }:
    let
      invisible = import (inputs.nix-invisible + /users/${config.home.username}.nix);
    in
    {
      sops.secrets."weather.json" = { };

      fonts.fontconfig.enable = true;
      home.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

      programs.hyprpanel = {
        enable = true;
        settings = {
          theme.font.name = "JetBrainsMono Nerd Font Mono";
          menus = {
            clock.weather = {
              unit = "metric";
              inherit (invisible) location;
              key = config.sops.secrets."weather.json".path;
            };
            dashboard = {
              directories.enabled = false;
              stats.enabled = false;
            };
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
